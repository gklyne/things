// odh = Outside diameter of hub
// odf = Outside diameter of flange
// id = inside (hole) diameter
// rt = retainer thickness (on axis)
// ft = Flange thicckness
// ll = lever length
// lt = lever thickness (width)
// tilt = tilt angle for clamping affect
// d  = delta

tilt = 0.85; // reduction in height on shorter side of hub

module PrintBedRetainer(odh, odf, id, rt, ft, ll, lt, tilt, d)
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
            translate([0,0,rt-(abs(tilt)*0.5)])
                rotate([atan(tilt/odh),0,0])
                    translate([0,0,ft/2])
                        cube([odf+ft,odf+ft,ft], center=true);
            translate([0,0,-d])
                cylinder(r1=id, r2=0, h=id*0.5);
        }
    }
}

// Actual objects here

ll = 15;	// Lever length

for (xo = [-1, 1])
{
    for ( yo = [-1, 1])
    {
        translate([ll*xo, ll*yo, 0])
        //              od1  od2 id rt ft  ll lt             d
        PrintBedRetainer(13,  18, 4, 6, 2, ll, 4, tilt*yo, 0.1);
    }
}

////              od1  od2 id rt ft  ll lt          d
//PrintBedRetainer(12,  16, 4, 6, 2, ll, 3, tilt, 0.1);


