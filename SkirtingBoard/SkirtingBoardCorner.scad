// Delta overlap to avoidf coincident surface
delta = 0.01;

// h = height of skirting
// t = thickness of skirting
// l = overall length of skirting
module skirting(h, t, l)
{
    cylr = 1.2*t;
    cylh = sqrt(2*cylr*t - t*t);
    translate([-l/2,-t,0])
        intersection()
        {
            union ()
            {
                cube(size=[l,t,h-cylh]);
                translate([0,cylr,h-cylh]) rotate([0,90,0]) cylinder(r=cylr, h=l);
            }
            cube(size=[l,t,h]);
        }
}

// h = height of skirting
// t = thickness of skirting
// l = overall length of skirting
// e = end with profile: -1 = left, +1 = right
module skirtingEnd(h, t, l, e)
{
    difference()
    {
        skirting(h, t, l);
        translate([e*l/2,0,0]) rotate([0,0,-90*e]) skirting(h, t, 3*t);
    }
}

//skirtingEnd(100,15,200,1);

// h  = height of skirting
// t  = thickness of skirting
// l1 = length (cornert to wall) of left leg
// l1 = length (cornert to wall) of right leg
module skirtingLShape(h, t, l1, l2)
{
    union()
    {
        // Left leg
        translate([-l1/2+delta,0,0])
        {
            skirtingEnd(h, t, l1, -1);
        }
        // Right leg
        rotate([0,0,90]) translate([l2/2-delta,0,0])
        {
            skirtingEnd(h, t, l2, +1);
        }
        // Corner
        intersection()
        {
            skirting(h, t, l1+l2);
            rotate([0,0,90]) skirting(100, 15, 200);
        }
    }
}

skirtingLShape(100, 15, 20, 60);

//skirtingEnd(100,15,20,-1);

