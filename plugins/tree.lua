local props={rx=25,ry=25,DX=100,DY=100,STYLE="fill:none;",TYPE="rect",SHAPE="-",SMOOTH=false}

set_tree_props=function(P)
	for k,v in pairs(P) do
		props[k]=v
	end
	return props
end

local push=table.insert

local labels2tr
labels2tr=function(labels,nodes,level)
	level=level or 1
	nodes=nodes or {}
	local label,child=unpack(labels)
	local tr=node{LABEL=label or "node",LPOS="D8M",rx=props.rx,ry=props.ry,TYPE=props.TYPE,LEVEL=level or 1}
	push(nodes,tr)
	local sum,n=1
	if child then
		sum=0
		for i,v in ipairs(child) do
			n=labels2tr(v,nodes,level+1)
			tr[i]=n
			edge{tr,n,SHAPE=props.SHAPE,SMOOTH=props.SMOOTH,STYLE=props.STYLE}
			sum=sum+n.SUM
		end
	end
	tr.SUM=sum
	return tr
end

local calculate_xy_LR
calculate_xy_LR=function(tr,dx,dy,x,y) -- map a tree to a matrix plane
	tr.cx,tr.cy=x+tr.LEVEL*dx,y+(tr.SUM+1)/2*dy
	local sum
	for i=1,#tr do
		sum= (i>1) and (sum+tr[i-1].SUM) or 0
		calculate_xy_LR(tr[i],dx,dy,x,y+sum*dy)
	end
	return tr
end

make_tree_LR=function(labels)
	local nodes={}
	local tr=labels2tr(labels,nodes,1)
	return calculate_xy_LR(tr,props.DX,props.DY,0,0)
end

make_tree_UD=function(labels)
	local nodes={}
	local tr=labels2tr(labels,nodes,1)
	calculate_xy_LR(tr,props.DY,props.DX,0,0)
	for i,v in ipairs(nodes) do
		v.cx,v.cy=v.cy,v.cx
	end
	return tr
end
