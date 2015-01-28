local svg={
main=[[
]]
rect=[[<rect x="@cx-rx@" y="@cy-ry@" width="@rx+rx@" height="@ry+ry@" filter="@filter@"  style="@STYLE or ''@"/>]],
}


-- function for processing 'LPOS' strings
local lpos_f=function(str)
	
end
svg.LPOS=lpos_f

-- function for processing 'STYLE' strings
local style_f=function()
	
end
svg.STYLE=style_f

-- function for processing edges
local EDGE_KEY="__EDGE__"
local edge_f=function()
	
end
svg[EDGE_KEY]=f

local type,setfenv,loadstring,gsub=type,setfenv,loadstring,string.gsub

-- function to make function to eval input string
local make_eval_string_func=function(env)
	if type(env)=="string" then return env end
	local loadstring,setfenv,tostring=loadstring,setfenv,tostring
	return function(str)
		local func=loadstring("return "..str)
		func= env and  env and setfenv(func,env) or func
		return tostring(func())
	end
end

-- map an obj to string according to 'key'
local map
map=function (obj,x,y)
	-- update cx,cy of the obj
	x,y=x or 0, y or 0
	obj.cx,obj.cy=obj.cx+x,obj.cx+y
	-- process self
	local str
	local key=obj.TYPE
	local e=svg[key]
	local tp=type(e)
	if tp=="string" then
		str= gsub(e,"@(.-)@",make_eval_string_func(obj))
	elseif tp=="function" then
		str= e(value)
	end
	-- process children
	if obj.CHILDREN then
		local t={}
		x,y=obj.cx,obj.cy
		for i,v in ipairs(obj.CHILDREN) do
			t[i]=map(v,x,y)
		end
		str=str..(table.concat(t))
	end
	return str
end

return map

---------------------------------------
-- test part
---------------------------------------

--~ print(map("rect",{cx=0,cy=0,ry=100,rx=100}))