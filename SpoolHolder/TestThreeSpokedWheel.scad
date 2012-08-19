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

t  = 2.5;    // thickness of hub tube

module TestThreeSpokedWheel(rd, rt, hd, ht, ad, at)
{
    d  = 1;
    
    difference()
    {
        union()
        {
            tube(hd, hd-2*t, ht);
            threespokes(rd, 4, rt);
        }
        translate([0,0,-d]) 
            cylinder(r=ad/2, h=at+2*d);    
    }
}

axledia = 8+0.25;

TestThreeSpokedWheel(38+6, 3, 38, 3, axledia, 3);

// Just the rim:
translate([45,0,0]) tube(38,38-2*t,3);

