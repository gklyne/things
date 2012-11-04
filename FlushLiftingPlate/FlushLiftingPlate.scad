// Non-return plate for loo flush
//
// This plate lifts water to start the syphon
// that flushes the loo, then lifts to allow
// water to fill the flush chamber

d1 = 125;    // Outside diameter
d2 = 12;     // Lift shaft diameter
d3 = 90;     // Inner diameter of upflow vent
d4 = 100;    // Outer diameter of upflow vent
w1 = 4;      // Width of rims
w2 = 6;      // Width of spokes
w3 = 10;     // Width of hub
t1 = 1.2;    // Thickness (height) of fill plate
t2 = 4;      // Thickness (height) of main ribs
t3 = 2;      // Thickness (height) of inner rim

use <../ShapeLibrary/CylinderShell.scad>

// CylinderShell(20,2,25);

module RibbedPlate()
{
  CylinderShell(d1,w1,t2);        // outer rim
  CylinderShell(d1,(d1-d4)/2,t1); // outer rim flange
  CylinderShell(d2+w3*2,w3,t2);   // hub
  CylinderShell(d3,w1,t3);        // inner rim
  CylinderShell(d3,(d3-d2)/2,t1); // infill
  for (i = [0:5])
  {
    rotate([0,0,i*60])
      translate([d2/2,-w2/2,0])
        cube(size=[(d1-d2-w1)/2,w2,t2]);
  }
}

RibbedPlate();
