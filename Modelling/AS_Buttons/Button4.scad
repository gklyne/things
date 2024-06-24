$fn=16;


module button(){

  translate([-1, 0, 0])
  sphere(r = 2);

  translate([-1, 0, 0])
  cylinder(h = 10, r = 2);

  translate([-1, 0, 10])
  sphere(r = 2);

  translate([-1, -2, 0])
  cube([5,4,10]);

  translate([-1, 0, 0])
  rotate([0,90,0])
  cylinder(h = 5, r = 2);

  translate([-1, 0, 10])
  rotate([0,90,0])
  cylinder(h = 5, r = 2);

  translate([3, -3, -0])
  cube([1,6,10]);

  translate([3, 0, 10])
  rotate([0,90,0])
  cylinder(h = 1, r =3);

  translate([3, 0, 0])
  rotate([0,90,0])
  cylinder(h = 1, r =3);
}


for (xo = [-20,0,20])
{
  for (yo = [-20,0,20])
  {
    translate( [xo, yo, 0] )
      rotate([0,90,0])
        button();
  }
}


//translate([-7, -4, -3])
//cube([6,6,6]);