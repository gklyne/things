// External chamfer along X-axis from given point which lies
// on the edge to be chamfered off, marked with "+":
//
//   +-.---
//   |/
//   .
//   |
//
// Point p is at one end, and the other end is at p+[l,0,0],
// (so the sign of l controls the direction to the other end).
//
// w is the size of the chamfer (distance from "+" to "." above).
//
// q=0 -> chamfer to +y,+z
// q=1 -> chamfer to -y,+z
// q=2 -> chamfer to -y,-z
// q=3 -> chamfer to +y,-z
// (Non-integral values of Q can tweak the chamfer angle,
// but the value of w is not preserved.)
//
// The chamfer is defined as a shape that is to be subtracted from
// the original to which the chamfer is applied.
//
module chamferX(p, l, w, q, d)
{
  xl = abs(l);
  xo = min(l,0);
  translate(p)
    rotate([45+q*90,0,0])
      translate([xo-d,0,-w])
        cube(size=[xl+2*d,w/sqrt(2),w*2]);
}

// External chamfer aligned with Y-axis
//
// q=0 -> chamfer to +x,+z
// q=1 -> chamfer to -x,+z
// q=2 -> chamfer to -x,-z
// q=3 -> chamfer to +x,-z
//
module chamferY(p, l, w, q, d)
{
  yl = abs(l);
  yo = min(l,0);
  translate(p)
    rotate([0,-45-q*90,0])
      translate([0,yo-d,-w])
        cube(size=[w/sqrt(2),yl+2*d,w*2]);
}

// External chamfer aligned with Z-axis
//
// q=0 -> chamfer to +x,+y
// q=1 -> chamfer to -x,+y
// q=2 -> chamfer to -y,-y
// q=3 -> chamfer to +y,-y
//
module chamferZ(p, l, w, q, d)
{
  zl = abs(l);
  zo = min(l,0);
  translate(p)
    rotate([0,0,45+q*90])
      translate([0,-w,zo-d])
        cube(size=[w/sqrt(2),w*2,zl+2*d]);
}

// X-axis internal chamfer located on/ending at a given edge;
// marked "+" or "*" here:
//
//   .-*---
//   |/
//   +
//   |
//
// Point p is at one end, and the other end is at p+[l,0,0],
// (so the sign of l controls the direction to the other end).
//
// w is the size of the chamfer (distance from "+" to "." above).
//
// q=0 -> chamfer to +z
// q=1 -> chamfer to -y
// q=2 -> chamfer to -z
// q=3 -> chamfer to +y
//
// Unlike the external chamfer, this defined shape is added to a shape to
// make the chamfer
//
module chamferXint(p, l, w, q, d)
{
  xl = abs(l);
  xo = min(l,0);
  translate(p)
    rotate([+45+q*90,0,0])
      translate([xo-d,0,0])
        cube(size=[xl+2*d,w*sqrt(2),w*sqrt(2)]);
}

// Y-axis internal chamfer located on/ending at a given edge
//
// q=0 -> chamfer to +z
// q=1 -> chamfer to -x
// q=2 -> chamfer to -z
// q=3 -> chamfer to +x
module chamferYint(p, l, w, q, d)
{
  yl = abs(l);
  yo = min(l,0);
  translate(p)
    rotate([0,-45-q*90,0])
      translate([0,yo-d,0])
        cube(size=[w*sqrt(2),yl+2*d,w*sqrt(2)]);
}


// Z-axis internal chamfer located on/ending at a given edge
//
// q=0 -> chamfer to +x
// q=1 -> chamfer to -y
// q=2 -> chamfer to -x
// q=3 -> chamfer to +y
module chamferZint(p, l, w, q, d)
{
  zl = abs(l);
  zo = min(l,0);
  translate(p)
    rotate([0,0,-45-q*90])
      translate([0,0,zo-d])
        cube(size=[w*sqrt(2),w*sqrt(2),zl+2*d]);
}

// Examples

union()
{
    difference()
    {
        cube([25,25,25]);
        translate([10,10,10]) cube([25,25,25]);
        chamferX([0,0,0],20,5,0,0.1);
        chamferY([0,0,0],20,5,0,0.1);
        chamferZ([0,0,0],20,5,0,0.1);
    }
   chamferXint([10,15,10],12,5,1,0.1);	// q=1 : -y
   chamferYint([15,10,10],12,5,1,0.1);  // q=1 : -x
   //chamferZint([15,10,10],25,5,2,0.1);  // q=2 : -x
   chamferZint([10,15,10],12,5,1,0.1);  // q=1 : -y
}

