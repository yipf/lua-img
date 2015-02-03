local match,tonumber=string.match,tonumber

str2xya=function(str,dx,dy)
	dx,dy=dx or 1, dy or 1
	local x,y,align=0,0,"middle"
	if not str then return x,y,align end
	local match,tonumber=string.match,tonumber
	v=match(str,"L(%d+)"); x=v and x-tonumber(v) or x
	v=match(str,"R(%d+)"); x=v and x+tonumber(v) or x
	v=match(str,"U(%d+)"); y=v and y-tonumber(v) or y
	v=match(str,"D(%d+)"); y=v and y+tonumber(v) or y
	return x*dx,y*dy, match(str,"S") and "start" or match(str,"E") and "end" or align
end