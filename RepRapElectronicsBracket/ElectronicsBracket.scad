use <../ShapeLibrary/Teardrop.scad>

// Reduce hole for clip-on slot
// Also used as extension to avoid coincident surfaces
delta = 0.5;

module RoundedEnd(l,r,h)
{
    union()
    {
      translate([0,0,0]) cylinder(r=r,h=h);
      translate([0,-r,0]) cube(size=[l+r,2*r,h]);
    }
}

module RoundedEnds(l,r,h)
{
    union()
    {
      translate([0,0,0]) cylinder(r=r,h=h);
      translate([l,0,0]) cylinder(r=r,h=h);
      translate([0,-r,0]) cube(size=[l,2*r,h]);
    }
}

module TaperedRoundedEnds(l,r,h)
{
    intersection()
    {
        RoundedEnds(l,r,h);
        rotate(asin(r/l), [0,0,-1]) RoundedEnd(l,r,h);
    }
}

module ElectronicsBracketBlank(length1, length2, holedia, offset, thickness)
{
    union()
    {
        // Arm segment that hangs on top rail
        rotate(asin(offset/length1), [0,0,-1])
        {
            translate([-length1,0,0])
            {
                difference()
                {
                    TaperedRoundedEnds(length1, holedia, thickness);
                    translate([0,0,-delta]) cylinder(r=holedia/2,h=thickness+2*delta);
                    // Cut-out for in situ clip-on attachment
                    rotate([0,0,-18])
                        translate([0,-(holedia-delta)/2,-delta])
                            cube([length1, holedia-delta, thickness+2*delta]);                        
                }
            }
        }
        // Arm segment for attaching mounting plate
        translate([0,-holedia/2,0])
        {
            rotate(asin(holedia/2/length2),[0,0,1])
            {
                TaperedRoundedEnds(length2, holedia/2, thickness);
            }
        }
    }
}


module ElectronicsBracket(length1, length2, holedia, offset, thickness, 
                          mountholes, mountholedia, orientation)
{
    difference()
    {
        if (orientation < 0)
            mirror([0,1,0])
                ElectronicsBracketBlank(length1, length2, holedia, offset, thickness);
        else
            ElectronicsBracketBlank(length1, length2, holedia, offset, thickness);
        // Mounting holes
        for (x = mountholes)
        {
            # translate([x,holedia,thickness/2])
                TeardropY(-holedia*3, mountholedia, 0);
            //    rotate([90,0,0]) 
            //        cylinder(r=mountholedia/2,h=holedia*3);
        }
    }
}

// Lay up mirrored pair of brackets
translate([0,20,0]) ElectronicsBracket(40, 78, 8, 9, 10, [5,15,25,35,45,55,65,75], 3, 1, $fn=8);
translate([0,-20,0]) ElectronicsBracket(40, 78, 8, 9, 10, [5,15,25,35,45,55,65,75], 3, -1, $fn=8);

