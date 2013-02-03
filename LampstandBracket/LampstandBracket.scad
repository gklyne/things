// Lampstand bracket

r1 = 20/2;     // Central hole
r2 = 32/2;     // Hub outer
r3 = 102/2-5;  // Rim inner
r4 = 102/2;    // Rim outer
r5 = 53;       // Flange outer
r6 = 30;       // Clamp elbow

to = 15;  // Thickness overall
tf = 2;   // Tickness flange
d  = 0.1; // delta

module tube(r1, r2, t)
{
  difference()
  {
    cylinder(r=r2, h=t);
    translate([0,0,-d/2])
      cylinder(r=r1, h=t+d);
  }
}

module spoke(ri, ro, t, wh, wr, a)
{
  rotate([0,0,a])
  {
    linear_extrude(height=t, twist=0)
    {
      polygon([[ri,-wh/2],
               [ri, wh/2],
               [ro, wr/2],
               [ro,-wr/2],
               [ri,-wh/2]]);
    }
  }
}

module teardropY(x, y1, y2, z, r)
{
  h = y2-y1;
  translate([x,y2,z])
  {
    rotate([90,0,0])
    {
      cylinder(r=r,h=h, $fn=8);
      rotate([0,0,45])
        cube(size=[r, r, h]) ;
    }
  }
}

// Vertical nut recess with base of nut centred on origin 
//
// af = nut size accross faces
// oh = overall height of recess
module nutrecessZ(oh, af)
{
  sin60 = sin(60);
  rotate([0,0,90])
  {
    cylinder(r=af/sin60/2, h=oh, $fn=6);
  }
}

module nutrecessY(x, y1, y2, z, af)
{
  translate([x,y2,z])
    rotate([90,0,0])
      nutrecessZ(y2-y1, af);
}

module bracket()
{
  difference()
  {
    union()
    {
      tube(r1, r2, to);  // Hub
      tube(r3, r4, to);  // Rim
      tube(r3, r5, tf);  // Flange
      spoke(r1, r3+d, to, 8, 12, 120);
      spoke(r1, r3+d, to, 8, 12, 240);
      spoke(r1, r3+d, to, 14, 18,  0);
    }
    translate([0,0,-d/2])
    {
      spoke(0,  r6+d, to+d, 3,   0.5, 0); 
      spoke(r6, r5+d, to+d, 0.5, 2,   0); 
    }
    teardropY(r2+2,  -8,  8, to/2, 2);
    nutrecessY(r2+2, -9, -6, to/2, 7.5);
    nutrecessY(r2+2,  6,  9, to/2, 7.5);
  }
}

bracket();