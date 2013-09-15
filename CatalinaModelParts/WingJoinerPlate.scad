// Catalina model wing joiner plate
//
// (part missing from Dynam kit)
//
platelength = 18;
platewidth  = 12;
platethick  = 1.5;
postdia     = 7;
postholedia = 2.0;
postheight  = 13;    // Overall, incl plate thickness
cornerrad   = 1;

// Define plate with radius corners
module plate(l,w,t,r)
{
  translate([-l/2, -w/2+r, 0]) cube(size=[l, w-2*r, t]);
  translate([-l/2+r, -w/2, 0]) cube(size=[l-2*r, w, t]);
  for (xo = [-l/2+r, l/2-r])
  {
    for (yo = [-w/2+r, w/2-r])
      {
        translate([xo, yo, 0]) cylinder(r=r, h=t, $fn=12);
      }
  }
}

module WingJoinerPlate()
{
  difference()
  {
    union()
    {
      plate(platelength, platewidth, platethick, cornerrad);
      cylinder(r=postdia/2, h=postheight, $fn=16);
    }
    translate([0,0,-1])
      cylinder(r=postholedia/2, h=postheight+2, $fn=8);
  }
}

// Lay up 4 copies.
for (xo = [-15, 15])
{
  for (yo = [-10, 10])
    {
      translate([xo, yo, 0]) WingJoinerPlate();
    }
}
