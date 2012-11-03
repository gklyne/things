// Non-return plate for loo flush
//
// This plate lifts water to start the syphon
// that flushes the loo, then lifts to allow
// water to fill the flush chamber

d1 = 100;    // Outside diameter
d2 = 8;      // Lift shaft diameter
d3 = 50;     // Diameter of inner flow hole
w  = 4;      // Width of ribs
t1 = 1.2;    // Thickness (height) of fill plate
t2 = 4;      // Thickness (height) of main ribs
t3 = 2.5;    // Thickness (height) of secondary ribs

use <../ShapeLibrary/CylinderShell.scad>

// CylinderShell(20,2,25);

module RibbedPlate()
{
  CylinderShell(d1,w,t2);
  CylinderShell(d2+w*2,w,t2);
  CylinderShell(d3+w*2,w,t3);
  CylinderShell(d1,(d1-d3)/2,t1);
  for (i = [0:5])
  {
    rotate([0,0,i*60])
      translate([d2/2,-w/2,0])
        cube(size=[(d1-d2-w)/2,w,t2]);
  }
}

RibbedPlate();
