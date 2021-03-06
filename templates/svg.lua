local template={
-- base elements
path=[[<path d = "@PATH@" fill = "@BGCOLOR or "none"@" stroke = "@COLOR@"  stroke-linejoin="round" marker-end = "@HEAD@" marker-mid="@MIDDLE@" marker-start="@TAIL@" style="@STYLE or ''@" filter="@FILTER@" />]],
label=[[<text x="@cx+lx@" y="@cy+ly@" stroke-width="0" fill="black" text-anchor="@align@">@LABEL@</text>]],
colorbox=[[<rect x="@cx-rx@" y="@cy-ry@" width="@rx+rx@" height="@ry+ry@" fill="@COLOR or '#ffffff'@" stroke="none"/>]],
-- nodes
rect=[[<rect x="@cx-rx@" y="@cy-ry@" width="@rx+rx@" height="@ry+ry@" filter="@filter@"  style="@STYLE or ''@"/>]],
roundrect=[[<rect x="@cx-rx@" y="@cy-ry@" rx="10" ry="10" width="@rx+rx@" height="@ry+ry@"  style="@STYLE or ''@" filter="@filter@"/>]],
ellipse=[[<ellipse cx="@cx@" cy="@cy@" rx="@rx@" ry="@ry@"   style="@STYLE or ''@" filter="@filter@" />]],
diamond=[[<path d="M @cx-rx@ @cy@ L @cx@ @cy-ry@ L @cx+rx@ @cy@ L @cx@ @cy+ry@ z"   style="@STYLE or ''@"  filter="@filter@" />]],
img=[[<image x="@cx-rx@" y="@cy-ry@" width="@rx+rx@" height="@ry+ry@" xlink:href="@SRC@" filter="@filter@"  style="@STYLE or ''@"/>]],
mulbox=[[<ellipse cx="@cx@" cy="@cy@" rx="@rx@" ry="@ry@"  fill="@COLOR or 'url(#linear0)'@" filter="@filter@"/><path d="M @cx-0.707*rx@ @cy-0.707*ry@ L @cx+0.707*rx@ @cy+0.707*ry@ M @cx-0.707*rx@ @cy+0.707*ry@ L @cx+0.707*rx@ @cy-0.707*ry@" />]],
addbox=[[<ellipse cx="@cx@" cy="@cy@" rx="@rx@" ry="@ry@"  fill="@COLOR or 'url(#linear0)'@" filter="@filter@"/><path d="M @cx-rx@ @cy@ L @cx+rx@ @cy@ M @cx@ @cy-ry@ L @cx@ @cy+ry@" />]],
database=[[
 <ellipse cx="@cx@" cy="@cy+ry@" rx="@rx@" ry="@ry/2@"  style="@STYLE or ''@" filter="@filter@"/>
 <rect x="@cx-rx@" y="@cy-ry@" width="@rx+rx@" height="@ry+ry@" style="@STYLE or ''@" filter="@filter@" stroke="none"/>
 <ellipse cx="@cx@" cy="@cy-ry@" rx="@rx@" ry="@ry/2@"  style="@STYLE or ''@" filter="@filter@"/>
 <path d="M @cx-rx@ @cy-ry@ L @cx-rx@ @cy+ry@ M @cx+rx@ @cy-ry@ L @cx+rx@ @cy+ry@" />
]],
-- colors
linear=	[[<linearGradient x1='0%' x2='100%' id='@KEY@' y1='0%' y2='100%'>
		<stop offset='0%' style='stop-color:@color1@;stop-opacity:1'/>
		<stop offset='100%' style='stop-color:@color2@;stop-opacity:1'/>
	</linearGradient>]],
radial=	[[<radialGradient id="@KEY@" cx="30%" cy="30%" r="50%">
		<stop offset="0%" style="stop-color:@color1@; stop-opacity:0" />
		<stop offset="100%" style="stop-color:@color2@;stop-opacity:1" />
 </radialGradient>]],
marker=[[<marker id="@KEY@" viewBox="0 0 @w@ @h@" refX="@cx@" refY="@cy@" markerUnits="strokeWidth"  stroke-width="0.5" markerWidth="@w@" markerHeight="@h@" orient="auto">
		@ELEMENT@
	</marker>]],
canvas=[[
<?xml version="1.0" standalone="no"?>
<!DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.1//EN" "http://www.w3.org/Graphics/SVG/1.1/DTD/svg11.dtd">
<svg width="@w or 1000@" height="@h or 1000@" version="1.1" xmlns="http://www.w3.org/2000/svg" font-size="@fs or 20@px" stroke-width = "@lw or 2@" fill="white" stroke="black" viewBox="0 0 @w or 1000@ @h or 1000@">
    <defs>
		<marker id="arrow" viewBox="0 0 20 20" refX="20" refY="10" markerUnits="strokeWidth" fill="black" markerWidth="8" markerHeight="6" orient="auto">
			<path d="M 0 0 L 20 10 L 0 20 L 10 10 z"/>
		</marker>
		<marker id="point2d" viewBox="0 0 20 20" refX="10" refY="10" markerUnits="strokeWidth" fill="orange" markerWidth="6" markerHeight="6" orient="auto">
			<circle cx="10" cy="10" r="9" />
		</marker>
				<marker id="point2d-black" viewBox="0 0 20 20" refX="10" refY="10" markerUnits="strokeWidth" fill="black" markerWidth="6" markerHeight="6" orient="auto">
			<circle cx="10" cy="10" r="9" />
		</marker>
		<marker id="point2d-white" viewBox="0 0 20 20" refX="10" refY="10" markerUnits="strokeWidth" fill="white" markerWidth="6" markerHeight="6" orient="auto">
			<circle cx="10" cy="10" r="9" />
		</marker>
		<marker id="point2d-gray" viewBox="0 0 20 20" refX="10" refY="10" markerUnits="strokeWidth" fill="#888888" markerWidth="6" markerHeight="6" orient="auto">
			<circle cx="10" cy="10" r="9" />
		</marker>
		 <filter id='shadow' filterRes='50' x='0' y='0'>
			<feGaussianBlur stdDeviation='2 2'/>
			<feOffset dx='2' dy='2'/>
		</filter>
		<linearGradient x1='0%' x2='100%' id='linear0' y1='0%' y2='100%'>
			<stop offset='0%' style='stop-color:rgb(255,255,255);stop-opacity:1'/>
			<stop offset='100%' style='stop-color:rgb(220,220,220);stop-opacity:1'/>
		</linearGradient>
		<linearGradient x1='0%' x2='100%' id='multi0' y1='100%' y2='100%'>
			<stop offset='0%' style='stop-color:rgb(255,255,255);stop-opacity:1'/>
			<stop offset='45%' style='stop-color:rgb(255,255,255);stop-opacity:1'/>
			<stop offset='46%' style='stop-color:rgb(0,0,0);stop-opacity:1'/>
			<stop offset='50%' style='stop-color:rgb(0,0,0);stop-opacity:1'/>
			<stop offset='54%' style='stop-color:rgb(0,0,0);stop-opacity:1'/>
			<stop offset='55%' style='stop-color:rgb(220,220,220);stop-opacity:1'/>
			<stop offset='100%' style='stop-color:rgb(220,220,220);stop-opacity:1'/>
		</linearGradient>
		<linearGradient x1='100%' x2='0%' id='multi1' y1='100%' y2='100%'>
			<stop offset='0%' style='stop-color:rgb(255,255,255);stop-opacity:1'/>
			<stop offset='45%' style='stop-color:rgb(255,255,255);stop-opacity:1'/>
			<stop offset='46%' style='stop-color:rgb(0,0,0);stop-opacity:1'/>
			<stop offset='50%' style='stop-color:rgb(0,0,0);stop-opacity:1'/>
			<stop offset='54%' style='stop-color:rgb(0,0,0);stop-opacity:1'/>
			<stop offset='55%' style='stop-color:rgb(220,220,220);stop-opacity:1'/>
			<stop offset='100%' style='stop-color:rgb(220,220,220);stop-opacity:1'/>
		</linearGradient>
		<linearGradient x1='100%' x2='0%' id='multi2' y1='100%' y2='100%'>
			<stop offset='0%' style='stop-color:rgb(255,255,255);stop-opacity:1'/>
			<stop offset='45%' style='stop-color:rgb(255,255,255);stop-opacity:1'/>
			<stop offset='46%' style='stop-color:rgb(0,0,0);stop-opacity:1'/>
			<stop offset='50%' style='stop-color:rgb(0,0,0);stop-opacity:1'/>
			<stop offset='54%' style='stop-color:rgb(0,0,0);stop-opacity:1'/>
			<stop offset='55%' style='stop-color:rgb(255,255,255);stop-opacity:1'/>
			<stop offset='100%' style='stop-color:rgb(255,255,255);stop-opacity:1'/>
		</linearGradient>
		<radialGradient id="radial0" cx="30%" cy="30%" r="50%">
			<stop offset="0%" style="stop-color:rgb(255,255,255); stop-opacity:0" />
			<stop offset="100%" style="stop-color:rgb(0,0,255);stop-opacity:1" />
     </radialGradient>
	 @DEFS or ""@
     </defs>
	@BODY or ""@
</svg>
]]
}

return template