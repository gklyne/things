// Vertical nut recess with base of nut centred on origin 
//
// Includes countersing at base of nut for downward-facing print
//
// af = nut size accross faces
// oh = overall height (screw + head + recesss)
// sd = screw diameter
// sh = screw height (to shoulder of nut recess)
//
module nutrecessZcs(af, oh, sd, sh)
{
  sin60 = sin(60);
  union()
  {
    // % translate([0,0,oh-sh]) cylinder(r=af/sin60/2, h=5, $fn=12);
    // Square shoulder...
    //cylinder(r=af/sin60/2, h=oh-sh, $fn=6);
    // Angle shoulder at 45deg for printing...
    intersection()
    {
        translate([0,0,-sh]) cylinder(r=af/sin60/2, h=oh, $fn=6);
        translate([0,0,-af/4])
          cylinder(r1=sd/2, r2=sd/2+(oh-sh), h=oh-sh+af/4, $fn=12);
    }
    translate([0,0,-sh]) cylinder(r=sd/2, h=oh, $fn=12);
  }
}

// Nut recess with screw directed along negative X-axis
module nutrecessXcs(od, oh, sd, sh)
{
    rotate([0,90,0]) nutrecessZcs(od, oh, sd, sh);
}

// Nut recess with screw directed along negative Y-axis
module nutrecessYcs(od, oh, sd, sh)
{
    rotate([90,0,0]) nutrecessZcs(od, oh, sd, sh);
}


// Examples
nutrecessZcs(7, 20, 4, 15);

translate([0,15,0]) nutrecessXcs(7, 20, 4, 10);

translate([15,0,0]) nutrecessYcs(7, 20, 4, 10);

