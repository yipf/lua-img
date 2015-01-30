local WORK_DIR="/home/yipf/lua-svg-lab"

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
local nodes,edges={},{}
local G={nodes=nodes,edges=edges,TYPE="canvas"}

local push,pop=table.insert,table.remove
node=function(n)
	n.rx,n.ry=n.rx or 0,n.ry or 0
	n.cx,n.cy=n.cx or 0,n.cy or 0
	n.TYPE=n.TYPE or "circle"
	push(nodes,n)
	return n,#nodes
end

edge=function(e)
	push(edges,e)
	return e,#edges
end

set_props=function(props)
	for k,v in pairs(props) do
		G[k]=v
	end
end

register_hook=function(key,value,border_func)
	rawset(template,key,value)
	register_border_func(border_func)
end

export=function(filepath)
	local nodes,edges=nodes,edges
	local t={}
	local push=table.insert
	for i,n in ipairs(nodes) do
		t[i]=node2str(n,template)
	end
	for i,e in ipairs(edges) do
		push(t,edge2str(e,template))
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
			local cmd=string.format("convert %q  -trim +repage %q",svg_filepath,filepath)
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