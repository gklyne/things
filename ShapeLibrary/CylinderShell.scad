// Cylinder shell

// Cylinder shell on X-Y plane, centred on Z axis,
// with outside diameter, shell thickness t and height h
module CylinderShell(d, t, h)
{
  difference()
  {
    cylinder(r=d/2,h=h);
    translate([0,0,-1]) cylinder(r=d/2-t,h=h+2);
  }
}

// CylinderShell(20,2,25);
