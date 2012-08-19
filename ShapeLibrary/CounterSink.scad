// Vertical countersink with top of countersink centred on origin 
//
// od = overall diameter (for screw head)
// oh = overall height (screw + head +recesss)
// sd = screw diameter
// sh = screw height (to top of countersink)
module countersinkZ(od, oh, sd, sh)
{
    union()
    {
        intersection()
	    {
            translate([0,0,-sh]) cylinder(r=od/2, h=oh, $fn=12);
            translate([0,0,-od/2]) cylinder(r1=0, r2=oh+od/2, h=oh+od/2, $fn=12);
        }
    translate([0,0,-sh]) cylinder(r=sd/2, h=sh, $fn=12);
    }
}

// Countersink with screw directed along negative X-axis
module countersinkX(od, oh, sd, sh)
{
    rotate([0,90,0]) countersinkZ(od, oh, sd, sh);
}

// Countersink with screw directed along negative Y-axis
module countersinkY(od, oh, sd, sh)
{
    rotate([90,0,0]) countersinkZ(od, oh, sd, sh);
}


// Examples
countersinkZ(8, 20, 4, 10);

translate([0,15,0]) countersinkX(8, 20, 4, 10);

translate([15,0,0]) countersinkY(8, 20, 4, 10);

