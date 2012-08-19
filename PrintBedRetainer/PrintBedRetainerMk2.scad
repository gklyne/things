// od1 = Outside diameter at base
// od2 = Outside diameter at top
// id = inside (hole) diameter
// rt = retainer thickness
// ho = hole offset
// ll = lever length
// lt = lever thickness (width)
// d  = delta
module PrintBedRetainer(od1, od2, id, rt, ho, ll, lt, d)
{
    s30 = sin(30);
    c30 = cos(30);
    lfr = (od1+od2)/4-lt;     // Lever fillet radius      
    lfp = (od1+od2)/4+lfr;    // Lever fillet pitch radius
    intersection()
    {
        difference()
        {
            union()
            {
                cylinder(r1=od1/2, r2=od2/2, h=rt);
                translate([0,-od1/4,0]) cube(size=[ll, od1/2, rt]);
            }
                translate([0,ho,-d]) cylinder(r=id/2, h=rt+2*d, $fn=12);    
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
        }
    }
}

// Actual objects here

ll = 14;
for (xo = [-ll, ll])
{
    for ( yo = [-ll, ll])
    {
        translate([xo, yo, 0])
        //               od1 od2 id rt  ho   ll  lt d
        PrintBedRetainer(13,  11, 4, 6, 0.75*sign(yo), ll, 3, 1);
    }
}

