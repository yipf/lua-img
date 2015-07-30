local WORK_DIR="/home/yipf/lua-img"

----------------------------------------------------------------------------------------
-- import template
----------------------------------------------------------------------------------------
package.path=WORK_DIR.."/?.lua;"..package.path 	-- add path of templates
local template=require "templates/svg"

----------------------------------------------------------------------------------------
-- util functions
----------------------------------------------------------------------------------------

require "utils/things2str"
local node2str,edge2str,style2str=node2str,edge2str,style2str

require "utils/str2things"
local str2offset=str2xya

require "utils/calculate"
local get_border=get_border
----------------------------------------------------------------------------------------
-- core functions
----------------------------------------------------------------------------------------
-- variables to store nodes and edges
local EDGE_KEY="__EDGE__"
local G={nodes=nodes,edges=edges,TYPE="canvas"}

local push,pop=table.insert,table.remove
node=function(n)
	n.rx,n.ry=n.rx or 0,n.ry or 0
	n.cx,n.cy=n.cx or 0,n.cy or 0
	n.TYPE=n.TYPE or "circle"
	push(G,n)
	local id=#G
	n.ID=id
	n.LEVEL=n.LEVEL or 0
	return n,id
end

edge=function(e)
	assert(#e>1)
	e.TYPE=EDGE_KEY
	push(G,e)
	local id=#G
	e.ID=id
	e.LEVEL=e.LEVEL or 1
	return e,id
end

local huge=math.huge
local max,min=math.max,math.min
group=function(g)
	local xmin,ymin,xmax,ymax,lmin=huge,huge,-huge,-huge,huge
	local cx,cy,rx,ry
	for i,v in ipairs(g) do
		cx,cy,rx,ry=v.cx,v.cy,v.rx,v.ry
		xmin=min(cx-rx,xmin)
		ymin=min(cy-ry,ymin)
		xmax=max(cx+rx,xmax)
		ymax=max(cy+ry,ymax)
		lmin=min(v.LEVEL,lmin)
	end
	cx=(xmin+xmax)/2
	cy=(ymin+ymax)/2
	rx=(xmax-xmin)/2
	ry=(ymax-ymin)/2
	local xoffset=g.xoffset or g.offset or 0
	local yoffset=g.yoffset or xoffset
	g.cx,g.cy,g.rx,g.ry=cx,cy,rx+xoffset,ry+yoffset
	g.LEVEL=lmin-1
	return node(g)
end

set_props=function(props)
	for k,v in pairs(props) do
		G[k]=v
	end
end

-- if no arguments are given, remove all elements; if given s, then remove nums elements from s.
remove_elements=function(s,nums)
	local n=#G
	nums=nums or s and 1 or #G 
	s=s or 1
	for i=s+nums,n do		G[i].ID=i-nums		end -- update ID of rest elements
	local remove=table.remove
	for i=1,nums do		remove(G,s)	end -- remove elements one by one
	return #G
end

swap_elements=function(id1,id2)
	local n,id
	n=G[id1]
	G[id1]=G[id2]	G[id1].ID=id1
	G[id2]=n			G[id2]=id2
end

register_node_hook=function(key,value,border_func)
	rawset(template,key,value)
	register_border_func(border_func)
end

local sort_f=function(a,b)
	return a.LEVEL<b.LEVEL
end

export=function(filepath)
	local nodes,edges=nodes,edges
	local t={}
	local push=table.insert
	local func
	table.sort(G,sort_f)
	for i,obj in ipairs(G) do
		func=obj.TYPE==EDGE_KEY and edge2str or node2str
		push(t, func(obj,template))
	end
	G.BODY=table.concat(t,"\n")
	local str=node2str(G,template)
	if not filepath then
		print(str)
	else -- generate img file according to filepath
		local filename,ext=string.match(filepath,"^(.+)%.(.-)$")
		if not ext then
			filename=filepath
		end
		local svg_filepath=filename..".svg"
		print(string.format("generating %q ...",svg_filepath))
		local f=io.open(svg_filepath,"w")
		f:write(str)
		f:close()
		print("Done!")
		if ext and ext~="svg" then -- if other image format, convert the svg file to that format
			print(string.format("generating %q ...",filepath))
--~ 			local cmd=string.format("convert %q  -trim +repage %q",svg_filepath,filepath) -- is fast but sometimes make mistake
			local cmd=string.format("inkscape -e %q -z -D %q",filepath,svg_filepath) -- is stable and high-quality but slow
			print(io.popen(cmd):read("*a"))
			print("Done!")
		end
	end
	return str
end

----------------------------------------------------------------------------------------
-- argument processing
----------------------------------------------------------------------------------------

local filepath=...
if filepath then
	dofile(filepath)
else
	print("Need valid file path!")
end