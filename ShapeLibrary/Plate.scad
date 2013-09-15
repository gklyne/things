// Define plate with radius corners
module plate_radius_corners(l,w,t,r)
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
