// Single object
module springseat(od, id, boltd, totalh, flangeh)
{
  or = od/2;
  ir = id/2;
  br = boltd/2;
  difference()
  {
    union() { 
      cylinder(r=ir, h=totalh); 
      cylinder(r=or, h=flangeh); 
    }
    translate([0,0,-6]) { 
      cylinder(r=br, h=totalh+10, $fn=12); 
    }
  }
}

// Main object array:
outerd = 13;
innerd = 9.5;
holed  = 4.5;   // +0.5 for M4 bolt
totalh = 6;
endh   = 3;

// Implicit union of all objects
pitch = outerd+10;
for (x = [-1.5*pitch,-0.5*pitch,0.5*pitch,1.5*pitch]) {
  for (y = [-0.5*pitch,0.5*pitch]) {
    translate([x,y,0]) { 
      springseat(outerd, innerd, holed, totalh, endh); 
    }
  }
}