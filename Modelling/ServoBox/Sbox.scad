module top()
{
  translate([-5.5, 0,0])
    cube([56,23,4]);
  cube([45.5,23,27]);
}


module halfbox()
{
  difference() 
  {
    top();
    translate([1.5, 1.5,-4.5])
      cube([42.5,20,30]);
    translate([-7, -4,-1])
      # cube([60,15,30]);
    translate([(45.5-49)/2,16.5,-1])
      cylinder(r=1,h=6);
    translate([(45.5+49)/2,16.5,-1])
      cylinder(r=1,h=6);
  }
}

for (yo = [5,-30])
{
  translate([0,yo,0])
    rotate([-90,0,0]) translate([0,-23,0]) halfbox();
}

// top();