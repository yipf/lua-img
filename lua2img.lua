local WORK_DIR="/home/yipf/lua-svg-lab"

----------------------------------------------------------------------------------------
-- import template
----------------------------------------------------------------------------------------
package.path=WORK_DIR.."/?.lua;"..package.path 	-- add path of templates
local graphic2str,node2str,edge2str=unpack(require "templates/svg")
if not node2str then  return print("templates can't be imported'") end

----------------------------------------------------------------------------------------
-- core functions
----------------------------------------------------------------------------------------
-- variables to store nodes and edges
local nodes,edges={},{}
local G={nodes=nodes,edges=edges}

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

local make_filepath=function(filename)
	
	return string.format("%s.%s",ext and filename,ext or "svg")
end

export=function(filepath)
	local nodes,edges=nodes,edges
	local t={}
	local push=table.insert
	for i,n in ipairs(nodes) do
		t[i]=node2str(n)
	end
	for i,e in ipairs(edges) do
		push(t,edge2str(e))
	end
	G.BODY=table.concat(t)
	local str=canvas2str(G)
	if not outfile then
		print(str)
	else -- generate img file according to filepath
		local filename,ext=string.match(filepath,"^(.+)%.(.-)$")
		if not ext then
			filename=filepath
		end
		local svg_filepath=filepath..".svg"
		local f=io.open(svg_filepath,"w")
		f:write(str)
		f:close()
		if ext and ext~="svg" then -- if other image format, convert the svg file to that format
			local cmd=string.format("convert %q %q",svg_filepath,filepath)
			print(io.popen(cmd):read("*a"))
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