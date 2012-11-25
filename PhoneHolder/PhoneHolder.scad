// Boat phone holder

delta = 0.001;    // Extra distance to avoid coincident surfaces 
sqrt2 = sqrt(2);

hp    = 150;      // Height of phone
wp    = 85;       // Width of phone
dp    = 14;       // Depth opf phone
dpe   = 12;       // Depth of phone at edge

module Bevel(l,t,orientation)
{
  // Bevel with corner along +X axis from origin, with orientation:
  //  0 -> facing +Y, +Z
  //  1 -> facing -Y, +Z
  //  2 -> facing -Y, -Z
  //  3 -> facing +Y, -Z
  rotate([orientation*90,0,0])
  {
    intersection()
    {
      translate([0,0,-t])
        rotate([45,0,0])
          cube([l,t*sqrt2,t*sqrt2]);
      cube([l,t*2,t*2]);
    }
  }
}

module EdgeClasp(l,h,t,orientation)
{
  // Edge clip on X-Z plane, with orientation:
  //  0 -> facing +Y
  //  1 -> facing +X
  //  2 -> facing -Y
  //  3 -> facing -X
  //
  // l = extent along aligneed axis (from origin, + or -)
  // t = thickness of edge
  //
  la = abs(l);
  ls = orientation==0 || orientation == 3 ? l : -l ;
  rotate([0,0,-orientation*90])
    translate([0.5*(ls-la),-t,-delta])
    {
      cube([la,t,h]);
      Bevel(la,t*2.5,0);
      translate([0,0,h])
        Bevel(la,t*2.5,3);
    }
}

module AngledStrip(x1,y1,x2,y2,w,t)
{
  xd = x2-x1;
  yd = y2-y1;
  l = sqrt(xd*xd+yd*yd);
  translate([x1,y1,0])
  {
    rotate([0,0,atan2(yd,xd)])
    {
      translate([0,0,0])    cylinder(r=w/2, h=t, $fn=16);
      translate([0,-w/2,0]) cube([l,w,t]);
      translate([l,0,0])    cylinder(r=w/2, h=t, $fn=16);
    }
  }
}

module BasePlate(w,h,t,ws,wc)
{
  x1 = ws - wc/2;
  x2 = w/2;
  x3 = w - x1;
  y1 = wc/2;
  y2 = h - y1;
  hr = 2;
  yh = y2 - (2*hr);
  difference()
  {
    union()
    {
      translate([0,0,0]) cube([ws,h,t]);
      AngledStrip(x1,y1,x2,y2,wc,t);
      AngledStrip(x1,y2,x2,y1,wc,t);
      AngledStrip(x2,y1,x3,y2,wc,t);
      AngledStrip(x2,y2,x3,y1,wc,t);
      translate([w-ws,0,0]) cube([ws,h,t]);
    }
    translate([x1,yh,-delta]) cylinder(r=hr,h=t*2,$fn=10);
    translate([x2,yh,-delta]) cylinder(r=hr,h=t*2,$fn=10);
    translate([x3,yh,-delta]) cylinder(r=hr,h=t*2,$fn=10);
  }
}

module PhoneHolder(wp,hp,dp,t,ws,wc)
{
  translate([-t,-t,-t])  BasePlate(wp+t*2,hp+t*2,t,ws,wc);

  translate([-t,0,0])    EdgeClasp(ws,  dp, t, 0);
  translate([0,-t,0])    EdgeClasp(20,  dp, t, 1);
  translate([0,hp+t,0])  EdgeClasp(-30, dp, t, 1);

  translate([wp+t,0,0])  EdgeClasp(-ws, dp, t,0);
  translate([wp,-t,0])   EdgeClasp(20,  dp, t,3);
  translate([wp,hp+t,0]) EdgeClasp(-30, dp, t,3);
}

//Bevel(20,5,3);

//EdgeClasp(20,12,2,0);

//AngledStrip(10,10,20,-40,6,2);

t=2;

//BasePlate(wp+2*t, hp+2*t, t, 10, 6);

PhoneHolder(wp, hp, dp, t, 10, 5);

