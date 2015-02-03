

local props={rx=50,ry=25,dx=150,dy=100,style="fill:none;"}

set_flowchart_props=function(P)
	for k,v in pairs(P) do
		props[k]=v
	end
	return props
end

local default_taget={cx=0,cy=0}

require "utils/str2things"
local str2xya=str2xya

local cal_pos=function(str,target)
	local x,y=str2xya(str,props.dx,props.dy)
	target=target or default_taget
	return target.cx+x,target.cy+y
end

unit=function(tp,label,pos_str,target)
	local x,y=cal_pos(pos_str,target)
	return node{TYPE=tp or "rect",STYLE=props.STYLE,cx=x,cy=y,rx=props.rx,ry=props.ry,LABEL=label,LPOS="D8M"}
end

process=function(label,pos_str,target)
	return unit("rect",label,pos_str,target)
end

condition=function(label,pos_str,target)
	return unit("diamond",label,pos_str,target)
end

state=function(label,pos_str,target)
	return unit("ellipse",label,pos_str,target)
end

point_to=function(from,to,label,lpos,shape,reverse,smooth)
	local offset= shape=="C" and (reverse and -dw or dw) or shape=="U" and (reverse and -dh or dh)
	return edge{from,to;   LABEL=label,LPOS=label and (lpos or ""),SHAPE=shape,OFFSET=offset,SMOOTH=smooth,HEAD="url(#arrow)"}
end

------------------------------------------------------------
-- usage
------------------------------------------------------------

--~ require "flowchart"

--~ local start=state("start","DR3")
--~ local p1=process("p1","D",start)
--~ local p2=process("p2","D",p1)
--~ local c=condition("c?","D",p2)
--~ local p3=process("p3","D",c)
--~ local p4=process("p4","R",p3)
--~ local _end=state("end","D",p3)

--~ point_to(start,p1)
--~ point_to(p1,p2)
--~ point_to(p2,c)
--~ point_to(c,p3,"no","R5S","-")
--~ point_to(c,p4,"yes","U5M","7")
--~ point_to(p3,_end)
--~ point_to(p4,_end,"","","N")

--~ export("test-flowchart.svg")
