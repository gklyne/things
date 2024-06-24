module tube(od, id, l)
{
    d = 1;
    difference()
    {
        cylinder(r=od/2, h=l);
        translate([0,0,-d]) cylinder(r=id/2, h=l+2*d);
    }
}

module threespokes(od, et, t)
{
    d = 1;
    difference()
    {
        cylinder(r=od/2, h=t);
        for (a=[0,120,240])
            translate([od*cos(a),od*sin(a),-d])
                cylinder(r=0.5*(sqrt(3)*od-et), h=t+d*2);
    }
}


module SpoolHolder(rd, rt, hd, ht, ad, at)
{
    d  = 1;
    t  = 2.0;  // thickness of hub tube
    bh = 0.5;  // height of retaining bump
    bt = 4;    // thickness of retaining bump
    b2 = bh*2;
    // Outer rim
    difference()
    {
        union()
        {
            threespokes(rd, 4, rt);
            difference()
            {
                union()
                {
                    cylinder(r=hd/2, h=ht);
                    translate([0,0,ht-bt]) 
                        intersection()
                        {
                            cylinder(r1=hd/2, r2=hd/2+b2, h=bt);
                            cylinder(r1=hd/2+b2, r2=hd/2, h=bt);
                            threespokes(rd, 8, bt);
                        }
                }
                translate([0,0,-d]) 
                    cylinder(r=(hd/2)-t, h=ht+d);
            }
            cylinder(r=(ad/2)+t, h=at);
        }
        translate([0,0,-d]) 
            cylinder(r=ad/2, h=at+2*d);    
    }
}

module SpoolSpacer(ad,l)
{
    t = 2;
    tube(ad+2*t, ad, l);
    // Add lumps to help hold tube when drilling out to clean hole
    translate([-((ad+t)/2)-1.5*t,-t/2,0]) cube([1.5*t,t,t]);
    translate([((ad+t)/2),-t/2,0]) cube([1.5*t,t,t]);
}

axledia = 8+0.25;

// Lay down 2-off 38mm hubs and spacers
for (x = [-25,25])
{
    translate([x,0,0])
    {
        SpoolHolder(38+6, 3, 38, 10, axledia, 5);
        translate([0,30,0]) SpoolSpacer(axledia, 15) ;
        translate([0,50,0]) SpoolSpacer(axledia, 15) ;
        translate([0,-30,0]) SpoolSpacer(axledia, 6) ;
    }
}

// threespokes(20, 3, 5);

