local sqrt,abs=math.sqrt,math.abs

local in_range=function(x,min,max)
	return x>=min and x<=max
end

local ellipse_f=function(cx,cy,rx,ry,x,y)
	local dx,dy=x-cx,y-cy
	if cx==x then return cx,cy+(dy>=ry and ry or dy<=-ry and -ry or 0) end
	local t,aa,bb=(cy-y)/(cx-x),rx*rx,ry*ry
	dx=sqrt(aa*bb/(t*t*aa+bb))
	dy=abs(t*dx)
	return cx+(x>cx and dx or -dx),cy+(y>cy and dy or -dy)
end

local rect_f=function(cx,cy,rx,ry,x,y)
	local atan2,tan,pi=math.atan2,math.tan,math.pi
	local dx,dy=x-cx,y-cy
	local a1,a=atan2(dy,dx),atan2(ry,rx)  
	if a1>=a and a1<=pi-a then
		x,y=ry*dx/dy,ry
	elseif a1>=a-pi and a1<=-a then
		x,y=-ry*dx/dy,-ry
	elseif a1>=-a and a1<=a then
		x,y=rx,rx*dy/dx
	else
		x,y=-rx,-rx*dy/dx
	end
	return cx+x,cy+y
end

local diamond_f=function(cx,cy,rx,ry,x,y)
	local abs=math.abs
	local dx,dy=x-cx,y-cy
	local a=ry*abs(dx)/(rx*abs(dy)+ry*abs(dx))
	x,y=a*rx,(1-a)*ry
	x,y=dx<0 and -x or x, dy<0 and -y or y
	return cx+x,cy+y
end

local database_f=function(cx,cy,rx,ry,x,y)
	local atan2,tan,pi=math.atan2,math.tan,math.pi
	local dx,dy=x-cx,y-cy
	local a1,a=atan2(dy,dx),atan2(ry,rx)  
	if a1>0 and a1>a and a1<pi-a then
		return ellipse_f(cx,cy+ry,rx,ry/2,x,y)
	elseif a1<0 and a1<-a and a1>a-pi then
		return ellipse_f(cx,cy-ry,rx,ry/2,x,y)
	else
		return rect_f(cx,cy,rx,ry,x,y)
	end
	return rect_f(cx,cy,rx,ry+ry/2,x,y)
end

local border_funcs={ ['ellipse']=ellipse_f, ['diamond']=diamond_f, ['rect']=rect_f, ['img']=rect_f, ['roundrect']=rect_f,['database']=database_f}

-- calculate the border point from x,y to node
get_border=function(n,x,y)
	local f=border_funcs[n.TYPE]
	if f then
		return f(n.cx,n.cy,n.rx,n.ry,x,y)
	else
		return n.cx,n.cy
	end
end

register_border_func=function(key,func)
	rawset(border_funcs,key,func)
end

get_group_border=function(nodes)
	local huge=math.huge
	local xmin,ymin,xmax,ymax=huge,huge,-huge,-huge
	local min,max=math.min,math.max
	for i,v in ipairs(nodes) do
		xmin=min(v.cx-v.rx,xmin)
		ymin=min(v.cy-v.ry,ymin)
		xmax=max(v.cx+v.rx,xmax)
		ymax=max(v.cy+v.ry,ymax)
	end
	return xmin,ymin,xmax,ymax
end
