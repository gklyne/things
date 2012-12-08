// odh = Outside diameter of hub
// odf = Outside diameter of flange
// id = inside (hole) diameter
// rt = retainer thickness (on axis)
// ft = Flange thicckness
// ll = lever length
// lt = lever thickness (width)
// d  = delta

tilt = 0.75; // reduction in height on shorter side of hub

module PrintBedRetainer(odh, odf, id, rt, ft, ll, lt, d)
{
    s30 = sin(30);
    c30 = cos(30);
    lfr = (odh)/2-lt;     // Lever fillet radius      
    lfp = (odh)/2+lfr;    // Lever fillet pitch radius
    intersection()
    {
        difference()
        {
            union()
            {
                cylinder(r=odh/2, h=rt);
                cylinder(r=odf/2, h=ft);
                translate([0,-odh/4,0]) cube(size=[ll, odh/2, rt-ft]);
            }
            // Hole is widened at base to allow retainer to tilt
            translate([0,0,-d]) cylinder(r=id/2, h=2*rt, $fn=12);    
            translate([0,0,-d])
                rotate([atan(tilt/odh),0,0])
                    cylinder(r=id/2, h=2*rt, $fn=12);    
            translate([c30*lfp,-s30*lfp,-d])
            {   
                cylinder(r=lfr, h=rt+2*d);
                translate([0,-lfr,0]) cube(size=[ll, lfr*2, rt+2*d] );
            }
            translate([c30*lfp,+s30*lfp,-d])
            {   
                cylinder(r=lfr, h=rt+2*d);
                translate([0,-lfr,0]) cube(size=[ll, lfr*2, rt+2*d] );
            }
            translate([0,0,rt-(tilt*0.5)])
                rotate([atan(tilt/odh),0,0])
                    translate([0,0,ft/2])
                        cube([odf+ft,odf+ft,ft], center=true);
        }
    }
}

// Actual objects here

ll = 14;	// Lever length

for (xo = [-ll, ll])
{
    for ( yo = [-ll, ll])
    {
        translate([xo, yo, 0])
        //              od1  od2 id rt ft  ll lt    d
        PrintBedRetainer(12,  16, 4, 6, 2, ll, 3, 0.1);
    }
}

////              od1  od2 id rt ft  ll lt    d
//PrintBedRetainer(12,  16, 4, 6, 2, ll, 3, 0.1);


