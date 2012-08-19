delta = 0.1;
spacing = 5;

module box(l, w, h, t)
{
  t2 = t * 2;
  difference()
  {
    cube( size=[l,w,h] );
    translate([t,t,t])
      cube( size=[l-t2, w-t2, h-t]) ;
  }
}

module lid(l, w, t)
{
  t2 = t * 2;
  t4 = t * 4;
  difference()
  {
    union()
    {
      cube( size=[l, w, t] );
      translate( [t, t, t*0.5] )
        cube( size=[l-t2, w-t2, t*1.5] );
    }
    translate( [t2, t2, t] )
      cube( size=[l-t4, w-t4, t2] );
  }
}

module support(dl, dw, h, od, id, delta)
{
  //translate([dl+od/2, dw+od/2, delta])
  translate([dl, dw, delta])
    difference()
    { 
      cylinder(h=h-delta, r=od/2, $fa=30);
      translate([0,0,-delta])
        cylinder(h=h+delta, r=id/2, $fa=30);
    }
}

module case(l, w, h, t)
{
  // TBD...
  translate([spacing,0,0])
    box(l, w, h, t);
  translate([-spacing-l, 0, 0])
    lid(l, w, t);
}

// Nanode board:
nanode_length   = 72.5;
nanode_width    = 58;
nanode_hole_dia = 3;

nanode_hole_1_x = 2;
nanode_hole_1_y = 2.5;
nanode_hole_2_x = 2;
nanode_hole_2_y = 55.5;

nanode_hole_3_x = 70.5;
nanode_hole_3_y = 2.5;
nanode_hole_4_x = 70.5;
nanode_hole_4_y = 55.5;

nanode_hole_5_x = 65.5;  	// 7.0 from other end
nanode_hole_5_y = 23.25;
nanode_hole_6_x = 65.5;  	// 7.0 from other end
nanode_hole_6_y = 34.75;		// pitch 11.5

// Try it out
t = 1;		// Wall thickness
g = 0.5;       // gap around PCB
l = nanode_length+2*t+g*2;		// Length
w = nanode_width+2*t+g*2;		// Width
h = 12;		// Height
s = spacing;	// Spacing

translate([s,0,0])
{
  box(l, w, h, t);
  support(t+g+nanode_hole_1_x, t+g+nanode_hole_1_y, h*0.5, 5.1, 2, t/2); 
  support(t+g+nanode_hole_2_x, t+g+nanode_hole_2_y, h*0.5, 5.1, 2, t/2); 
  support(t+g+nanode_hole_3_x, t+g+nanode_hole_3_y, h*0.5, 5.1, 2, t/2); 
  support(t+g+nanode_hole_4_x, t+g+nanode_hole_4_y, h*0.5, 5.1, 2, t/2); 
  support(t+g+nanode_hole_5_x, t+g+nanode_hole_5_y, h*0.5, 5.1, 2, t/2); 
  support(t+g+nanode_hole_6_x, t+g+nanode_hole_6_y, h*0.5, 5.1, 2, t/2); 
}

translate([-s-l, 0, 0])
  lid(l, w, t);

//support(t+g+nanode_hole_1_x, t+g+nanode_hole_1_y, h*0.5, 5, 2, t/2); 

