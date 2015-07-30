local type,loadstring,setfenv,tostring=type,loadstring,setfenv,tostring
local push,concat,format,gsub=table.insert,table.concat,string.format,string.gsub

local make_eval_string_func=function(env)
	if type(env)=="string" then return env end
	return function(str)
		local func=loadstring("return "..str)
		func= env and setfenv(func,env) or func
		return tostring(func())
	end
end

local obj2str=function(key,value,template)
	local e=template[key]
	local tp=type(e)
	if tp=="string" then
		str= gsub(e,"@(.-)@",make_eval_string_func(value))
	elseif tp=="function" then
		str= e(value)
	end
	return str
end

----------------------------------------------------------------------------------------------
-- function to process styles
----------------------------------------------------------------------------------------------

local STYLE_FMTS={
	dashed="stroke-dasharray:10,3;",	
	dotted="stroke-dasharray:3,3;",
	fill="fill:%s;",
	stroke_width="stroke-width:%s;",
	stroke="stroke:%s;",
	noborder="stroke-width:0;",
	nofill="fill:none;",
	opacity="opacity:%f",
}
local style2str=function(style)
	if type(style)~="table" then return tostring(style) end
	local t={}
	for k,v in pairs(style) do
		k=STYLE_FMTS[k]
		if k then push(t,format(k,tostring(v))) end
	end
	return concat(t)
end

local process_style=function(obj)
	local style=obj.STYLE
	if style then obj.STYLE=style2str(style) end
end

----------------------------------------------------------------------------------------------
-- function to process lables
----------------------------------------------------------------------------------------------

require "utils/str2things"
local str2xya=str2xya

local str2lines=function(str)
	local lines={}
	for line in string.gmatch(str.."\n","(.-)\n") do
		push(lines,line)
	end
	return lines
end


local process_label=function(obj,template)
	local label,str=obj.LABEL,""
	local lx,ly,align=str2xya(obj.LPOS)
	obj.align=align
	label=str2lines(label)
--~ 	if type(label)=="table" then
		local n,offset=#label,obj.LOFFSET or 20 -- 'offset' is a variable to make label align center in vertical
		for i,v in ipairs(label) do
			obj.LABEL=v
			obj.lx,obj.ly=lx,ly+(i-(n+1)/2)*offset
			label[i]=obj2str("label",obj,template)
		end
		str=table.concat(label)
--~ 	else -- string
--~ 		obj.LABEL=tostring(label)
--~ 		obj.lx,obj.ly=lx,ly
--~ 		str=obj2str("label",obj,template)
--~ 	end
	return str
end

----------------------------------------------------------------------------------------------
-- function to generate edges
----------------------------------------------------------------------------------------------

require "utils/calculate"
local get_border=get_border

local shape2points=function(shape,from,to,offset)
	local points,cx,cy,x,y={}
	local fx,fy,tx,ty=from.cx,from.cy,to.cx,to.cy
	cx,cy=(fx+tx)/2,(fy+ty)/2
	local max,min=math.max,math.min
	offset=offset or 100
	shape=shape or "-"
	if shape=="-" then
		x,y=get_border(from,tx,ty);	points[1]={x,y}
		x,y=get_border(to,fx,fy);	points[2]={x,y}
	elseif shape=="L" then
		cx,cy=fx,ty
		x,y=get_border(from,cx,cy);	points[1]={x,y}
		points[2]={cx,cy}
		x,y=get_border(to,cx,cy);	points[3]={x,y}
	elseif shape=="7" then
		cx,cy=tx,fy
		x,y=get_border(from,cx,cy);	points[1]={x,y}
		points[2]={cx,cy}
		x,y=get_border(to,cx,cy);	points[3]={x,y}
	elseif shape=="Z" or shape=="C" then
		if shape=="C" then cx=(offset<0 and max(fx,tx) or min(fx,tx))-offset end
		x,y=get_border(from,cx,fy);	points[1]={x,y}
		points[2]={cx,fy}
		points[3]={cx,ty}
		x,y=get_border(to,cx,ty);	points[4]={x,y}
	elseif shape=="N" or shape=="U" then
		if shape=="U" then cy=(offset>0 and max(fy,ty) or min(fy,ty))+offset end
		x,y=get_border(from,fx,cy);	points[1]={x,y}
		points[2]={fx,cy}
		points[3]={tx,cy}
		x,y=get_border(to,tx,cy);	points[4]={x,y}
	end
	return points,cx,cy
end
local point2str=function(pre,point)
	return string.format("%s%d %d",pre,unpack(point))
end
local points2str=function(points,smooth,close)
	local t={point2str("M",points[1])}
	local pre,n="L",#points
	local push=table.insert
	local n,s=#points
	if smooth and n>2 then
		if (n-4)%2==0 then
			push(t,point2str("C",points[2])); push(t,point2str("",points[3])); push(t,point2str("",points[4]))
			for i=5,n,2 do	push(t,point2str("S",points[i])); push(t,point2str("",points[i+1]))	end
		else
			push(t,point2str("Q",points[2])); push(t,point2str("",points[3]))
			for i=4,n do	push(t,point2str("T",points[i]))		end
		end
	else
		for i=2,n do t[i]=point2str(pre,points[i])	end
	end
	if close then push(t,"Z") end
	return table.concat(t," ")
end

edge2str=function(e,template)
	process_style(e)
	local from,to=e[1]
	local points
	local t={}
	for i=2,#e do
		to=e[i]
		points,e.cx,e.cy=shape2points(e.SHAPE,from,to,e.OFFSET)
		e.PATH=points2str(points,e.SMOOTH,e.CLOSE)
		push(t,obj2str("path",e,template))
		if e.LABEL then		push(t,process_label(e,template)) 	end
		from=to
	end
	return table.concat(t,"\n")
end

----------------------------------------------------------------------------------------------
-- function to process nodes
----------------------------------------------------------------------------------------------

node2str=function(n,template)
	process_style(n)
	local tp=n.TYPE
	if tp=="path" then 	-- if a path element
		local x,y=n.cx,n.cy
		for i,v in ipairs(n) do
			v[1],v[2]=v[1]+x,v[2]+y
		end
		n.PATH=points2str(n,n.SMOOTH,n.CLOSE)
	end
	local str=tp and obj2str(tp,n,template) or ""
	if n.LABEL and tp and tp~="LABEL" then
		str=str..process_label(n,template)
	end
	return str
end
