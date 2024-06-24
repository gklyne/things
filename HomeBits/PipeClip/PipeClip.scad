use <../ShapeLibrary/CounterSink.scad>

// l   = length of clip
// w   = width (depth) of clip
// h   = height of clip
// pd  = pipe hole diameter
// pg  = pipe gap diameter
// shd = Screw head diameter
// ssd = screw shaft diameter
// d   = delta
module PipeClip(l, w, h, pd, pg, shd, ssd, d)
{
    difference()
    {
        translate([-l/2,0,0])
            cube(size=[l, w, h]);
        translate([0,-d,h]) 
            rotate([-90,0,0]) 
                cylinder(r=pg/2, h=w+2*d);
        translate([0,-d,h-pg/2]) 
            rotate([-90,0,0]) 
                cylinder(r=pd/2, h=w+2*d);
        translate([0,w/2,h-(pd+pg)/2]) 
            countersinkZ(shd, h+2*d, ssd, h+d-(pd+pg)/2);
        translate([l/2,-d,0]) 
            rotate([0,-15,0]) 
                cube(size=[l,w+2*d,h+w]);
        translate([-l/2,-d,0]) 
            rotate([0,15,0]) 
                translate([-l,0,0]) 
                    cube(size=[l,w+2*d,h+w]);
    }
}

l = 15;
w = 8;
p = l+w;
xn   = 3;
yn   = 3;
xlim = (xn-1)/2;
ylim = (yn-1)/2;

for (xo = [-xlim:xlim])
{
    for (yo = [-ylim:ylim])
    {
        translate([xo*p,yo*p,0])
            PipeClip(l, w, 9.5, 5.75, 4.75, 5, 3.5, 1);
    }
}


//PipeClip(15, 8, 10, 7, 6, 6, 3, 1);

//translate([0,-20,0]) countersink(6, 12, 3.5, 5, 1);