// Approximate segment for intersection/difference with circle
module segment2d(r,a)
{
    da = a/4;
    polygon(points=[[0,0], [r,0],
                    [r*cos(da*1),r*sin(da*1)],
                    [r*cos(da*2),r*sin(da*2)],
                    [r*cos(da*3),r*sin(da*3)],
                    [r*cos(da*4),r*sin(da*4)]
                   ],
            paths=[[0,1,2,3,4,5,0]]);
}

// Ring occupying specified angle:
// when extruded, a large angle gives a thicker extrided helix.
module ring2d(r1, r2, a)
{
    intersection()
    {
        difference()
        {
            circle(r1);
            circle(r2);
        }
    segment2d(r1*2,a);
    }
}

// Helix; recangular cross section
//   r1 = outer radius 
//   r2 = inner radius
//   h  = overall height
//   a  = turn angle (360=full turn)
//   b  = solid angle extruded (180=half height solid, 90=quarter, etc.)
module helix(r1, r2, h, a, b)
{
    linear_extrude(height=h, twist=a)
        ring2d(r1, r2, b);
}

// Single object
module springseat(od, id, boltd, totalh, flangeh, helixp, coild, delta)
{
  or = od/2;
  ir = id/2;
  br = boltd/2;
  helixh = totalh - flangeh;
  atwist = 360*helixh/helixp;  // Angle calculated from height and pitch
  abase  = 360*coild/helixp;   // Solid angle from coil thickness and pitch
  // Main body
  difference()
  {
    union() { 
      cylinder(r=ir, h=totalh);
      cylinder(r=or, h=flangeh); 
    }
    translate([0,0,-6]) { 
      cylinder(r=br,h=totalh+10, $fn=12); 
    }
  }
  // Helix to support spring
  // (3 helixes with decreasing diameters reduce horizontal overhang)
  translate([0,0,endh])
  {
    helix(innerd/2+coild, innerd/2-delta, helixh, atwist, abase);
    rotate([0,0,-45])
      helix(innerd/2+coild*0.66, innerd/2-delta, helixh, atwist, abase);
    rotate([0,0,-90])
      helix(innerd/2+coild*0.33, innerd/2-delta, helixh, atwist, abase);
  }
}

// Main object array:
outerd = 13;
innerd = 9.5;
holed  = 4.5;   // +0.5 for M4 bolt
totalh = 5;
endh   = 2;
helixp = 4;     // Pitch of helix
coild  = 1.5;   // Diameter of coil (wire)
delta  = 0.5;

//translate([0,0,endh])
//{
//    helix(innerd/2+coild, innerd/2-delta, totalh-endh, 
//          360*(totalh-endh)/helixp,  // Angle calculated from height and pitch
//          360*coild/helixp);         // Solid angle from could thickness and pitch
//    rotate([0,0,-45])
//        helix(innerd/2+coild*0.66, innerd/2-delta, totalh-endh, 
//              360*(totalh-endh)/helixp,
//              360*coild/helixp);
//    rotate([0,0,-90])
//        helix(innerd/2+coild*0.33, innerd/2-delta, totalh-endh, 
//              360*(totalh-endh)/helixp,
//              360*coild/helixp);
//}


// springseat(outerd, innerd, holed, totalh, endh, helixp, coild, delta);

// Implicit union of all objects
pitch = outerd+10;
//for (x = [-1.5*pitch,-0.5*pitch,0.5*pitch,1.5*pitch]) {
for (x = [-0.5*pitch,0.5*pitch]) {
  for (y = [-0.5*pitch,0.5*pitch]) {
    translate([x,y,0]) { 
      springseat(outerd, innerd, holed, totalh, endh, helixp, coild, delta);
    }
  }
}
