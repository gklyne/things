// Inline cleat for tying off cord-ends.

l1 = 90;  // Overall length
l2 = 24;  // Offset to centre of cleat
l3 = 40;  // Overall width of cleat
l4 = 10;  // Width of cleat neck
l5 = 12;  // Distance between buckle holes

d  = 5;    // Diameter of cord clearance hole

h1 = 13;  // Overall height of cleat
h2 = 4;   // Height of base
h3 = 4;   // Height of cleat neck
h4 = 6;   // Height of cleat jaw
h5 = 12;  // Overall height at centre of cleat

t = 4;    // Overall thickness

delta = 0.01;

// Supporting shapes
// -----------------

module RoundedRectangle(l, w, t, r)
{
    translate([r,0,0]) cube(size=[l-2*r,w,t]);
    translate([0,r,0]) cube(size=[l,w-2*r,t]);
    for (xo=[r, l-r])
    {
        for (yo=[r,w-r])
        {
            translate([xo,yo,0]) cylinder(r=r, h=t);
        }
    }
}

//RoundedRectangle(50, 20, 5, 8);

module SemiRoundedRectangle(l, w, t)
{
    r = w/2;
    translate([0,-r,0]) cube(size=[l-r,w,t]);
    cylinder(r=r, h=t);
}

//SemiRoundedRectangle(50, 20, 5);

module BuckleOutline(l, h, t, r)
{
    RoundedRectangle(l, h, t, r);
    intersection()
    {
        translate([r,h-r,0])
            rotate([0,0,180+45])
                translate([0, -r, 0])
                    cube(size=[l, h, t]);
        translate([-h,0,0])
            cube(size=[l+h, h, t]);
    }
}

//BuckleOutline(50, 20, 5, 8);

module CleatCutout(l, hn, hj, t)
{
    lc = l+hn/2;
    a = atan2(hj-hn,l);
    translate([hn/2,hn/2,-delta])
    {
        SemiRoundedRectangle(lc,hn,t+2*delta);
        rotate([0,0,a]) SemiRoundedRectangle(lc,hn,t+2*delta);
    }
}

//CleatCutout(20,3,5,4);

// Base
// -----------------
// Origin at bottom left
module Base(l, h, t)
{
    cube(size=[l,h,t]);
}

// Cleat
// -----------------
// Origin at bottom centre
module Cleat(l,ln,h,hn,hj,hc,t)
{
    lc = (l-ln)/2;
    a  = atan2(h-hc,l/2);
    difference()
    {
        translate([-l/2,0,0]) cube(size=[l,h,t]);
        translate([ln/2,0,0])
            CleatCutout(lc, hn, hj, t);
        translate([-ln/2,0,0])
            mirror([1,0,0])
                CleatCutout(lc, hn, hj, t);
        translate([0,hc,0])
            rotate([0,0,a])
                cube(size=[l/2,h,t]);
        translate([0,hc,0])
            mirror([1,0,0])
                rotate([0,0,a])
                    cube(size=[l/2,h,t]);
    }
}

//Cleat(l3,l4,h1,h3,h4,h5,t);

// Buckle
// -----------------
// Origin at bottom right
module Buckle(l, h, t, p, d, or)
{
    translate([-l,0,0])
    {
        difference()
        {
            BuckleOutline(l,h,t,or);
            translate([l/2+p/2,h/2,-delta]) cylinder(r=d/2,h=h+2*delta,$fn=8);
            translate([l/2-p/2,h/2,-delta]) cylinder(r=d/2,h=h+2*delta,$fn=8);
        }
    }
}

// Composed piece
// -----------------
module InlineCleat()
{
    or = h2+d/2;
    Base(l1-or, h2, t);
    translate([l2,h2-delta,0]) Cleat(l3,l4,h1-h2,h3,h4,h5-h2,t);
    translate([l1,0,0]) Buckle(h2+d/2+l5+d/2+h2, h2+d+h2, t, l5, d, or); 
}

// InlineCleat();

for (i = [0:3])
    translate([0,i*20,0]) InlineCleat();
