// Lampstand bracket

r1 = 19.5/2;   // Central hole
r2 = 32/2;     // Hub outer
r3 = 99.5/2-5; // Rim inner
r4 = r3+5;     // Rim outer
r5 = r4+3;     // Flange outer
r6 = 25+0;     // Clamp elbow

to = 15;  // Thickness overall
tf = 2;   // Tickness flange
d  = 0.1; // delta

module tube(r1, r2, t)
{
  difference()
  {
    cylinder(r=r2, h=t, $fn=48);
    translate([0,0,-d/2])
      cylinder(r=r1, h=t+d, $fn=48);
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

// Vertical nut recess with base of nut 
// centred on origin 
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

module splitspoke(cti, cto, a)
{
  rotate([0,0,a])
  {
    translate([0,0,-d/2])
    {
      spoke(0,  r6+d, to+d, 5,   0.1, 0); 
      spoke(r6, r5+d, to+d, 0.1, 2,   0); 
    }
    teardropY(r2+2,  -cto,  cto, to/2, 2);
    nutrecessY(r2+2, -cto, -cti, to/2, 7.5);
    nutrecessY(r2+2,  cti,  cto, to/2, 7.5);
  }
}

module bracket3()
{
  difference()
  {
    union()
    {
      tube(r1, r2, to);          // Hub
      tube(r3, r4, to);          // Rim
      tube(r3, r5, tf);          // Flange
      spoke(r1, r3+d, to,  8, 12, 120);
      spoke(r1, r3+d, to,  8, 12, 240);
      spoke(r1, r3+d, to, 16, 14, 0);
    }
    splitspoke(7, 9, 0); 
  }
}

module bracket4()
{
  difference()
  {
    union()
    {
      tube(r1, r2, to);  // Hub
      tube(r3, r4, to);  // Rim
      tube(r3, r5, tf);  // Flange
      spoke(r1, r3+d, to,  8, 12,  90);
      spoke(r1, r3+d, to,  8, 12, 270);
      spoke(r1, r3+d, to, 16, 14,   0);
      spoke(r1, r3+d, to, 16, 14, 180);
    }
    splitspoke(7, 9,   0); 
    splitspoke(7, 9, 180); 
  }
}

module bracket2()
{
  difference()
  {
    union()
    {
      tube(r1, r2, to);  // Hub
      tube(r3, r4, to);  // Rim
      tube(r3, r5, tf);  // Flange
      spoke(r1, r3+d, to,  8, 12,  90);
      spoke(r1, r3+d, to, 16, 14,   0);
      spoke(r1, r3+d, to, 16, 14, 180);
    }
    translate([-(r5+d),-(r5+d),-d/2])
      cube(size=[(r5+d)*2,r5+d,to+d]);
    splitspoke(7, 9,   0); 
    splitspoke(7, 9, 180); 
  }
}

// translate([0,5,0]) bracket2();
// translate([0,-5,0]) rotate([0,0,180]) bracket2();

bracket3();
