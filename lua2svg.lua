local WORK_DIR="/home/yipf/lua-svg-lab"

----------------------------------------------------------------------------------------
-- import template
----------------------------------------------------------------------------------------
package.path=WORK_DIR.."/?.lua;"..package.path 	-- add path of templates
local map=require "templates/svg"
if not map then  return print("templates can't be imported'") end

----------------------------------------------------------------------------------------
-- core functions
----------------------------------------------------------------------------------------
local G={TYPE="main"}
local push,pop=table.insert,table.remove
node=function(n)
	n.rx,n.ry=n.rx or 0,n.ry or 0
	n.cx,n.cy=n.cx or 0,n.cy or 0
	n.TYPE=n.TYPE or "circle"
	push(Gn)
	return n,#G
end

edge=function(e)
	e.TYPE="EDGE"
	push(G,e)
	return e,#G
end

set_props=function(props)
	for k,v in pairs(props) do
		G[k]=v
	end
end

export=function(g,x,y)
	g=g or G
	local t
	for i,v in ipairs(g) do
		t[i]=map(v,x,y)
	end
	g.BODY=table.concat(t)
	return map(g)
end

----------------------------------------------------------------------------------------
-- argument processing
----------------------------------------------------------------------------------------
--~ package.path=WORK_DIR.."plugins/?.lua;"..package.path -- add path of plugins
--~ local filepath=...
--~ if filepath then
--~ 	dofile(filepath)
--~ else
--~ 	print("Need valid file path!")
--~ end