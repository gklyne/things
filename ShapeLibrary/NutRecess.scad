// Vertical nut recess with base of nut centred on origin 
//
// af = nut size accross faces
// oh = overall height (screw + head + recesss)
// sd = screw diameter
// sh = screw height (to shoulder of nut recess)
module nutrecessZ(od, oh, sd, sh)
{
    sin60 = sin(60);
    union()
    {
        // % translate([0,0,oh-sh]) cylinder(r=od/sin60/2, h=5, $fn=12);
        // Square shoulder...
        //cylinder(r=od/sin60/2, h=oh-sh, $fn=6);
        // Angle shoulder at 45deg for printing...
        intersection()
	    {
            translate([0,0,-sh]) cylinder(r=od/sin60/2, h=oh, $fn=6);
            translate([0,0,-((od/2)-(sd/2))/2]) cylinder(r1=sd/2, r2=sd/2+(oh-sh), h=oh-sh, $fn=12);
        }
        translate([0,0,-sh]) cylinder(r=sd/2, h=oh, $fn=12);
    }
}

// Countersink with screw directed along negative X-axis
module nutrecessX(od, oh, sd, sh)
{
    rotate([0,90,0]) nutrecessZ(od, oh, sd, sh);
}

// Countersink with screw directed along negative Y-axis
module nutrecessY(od, oh, sd, sh)
{
    rotate([90,0,0]) nutrecessZ(od, oh, sd, sh);
}


// Examples
nutrecessZ(7, 20, 4, 10);

translate([0,15,0]) nutrecessX(7, 20, 4, 10);

translate([15,0,0]) nutrecessY(7, 20, 4, 10);

