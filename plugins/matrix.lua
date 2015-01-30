
local props={rx=25,ry=25,dw=100,dh=100,style="fill:none;",tp="ellipse"}

set_matrix_props=function(P)
	for k,v in pairs(P) do
		props[k]=v
	end
	return props
end

NONE={}

cell=function(label,tp,m,i,j)
	local n=node{TYPE=tp or props.tp,STYLE=props.style,cx=0,cy=0,rx=props.rx,ry=props.ry,LABEL=label,LPOS="D8M"}
	if m then
		m[i][j]=n
	end
	return n
end

make_matrix=function(m,x,y)
	x,y=x or 0, y or 0
	local dw,dh=props.dw,props.dh
	for i,row in ipairs(m) do
		for j,cell in ipairs(row) do
			if cell~=NONE then
				cell.cx,cell.cy=j*dw,i*dh
			end
		end
	end
end

connect=function(from,to,label,lpos,shape,reverse,smooth)
	if from==NONE or to==NONE then return end
	local dw,dh=props.dw,props.dh
	local offset= shape=="C" and (reverse and -dw or dw) or shape=="U" and (reverse and -dh or dh)
	return edge{FROM=from,TO=to,LABEL=label,LPOS=label and (lpos or ""),SHAPE=shape,OFFSET=offset,SMOOTH=smooth,HEAD="url(#arrow)"}
end

------------------------------------------------------------
-- usage
------------------------------------------------------------

--~ require "matrix"

--~ local m,row={}

--~ local ROW,COLUMN=9,9

--~ for i=1,ROW do
--~ 	row={}
--~ 	for j=1,COLUMN do
--~ 		row[j]= i==j and cell("M"..i..j) or NONE
--~ 	end
--~ 	m[i]=row
--~ end

--~ for i,r in ipairs(m) do
--~ 	if i<#m then
--~ 		for i,c in ipairs(m[i+1]) do
--~ 			connect(r[1],c)
--~ 		end
--~ 	end
--~ end

--~ make_matrix(m)

--~ export("test-matrix.svg")


