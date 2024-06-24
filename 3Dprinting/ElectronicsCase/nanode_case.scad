// This version of the box and lid design is specialized as a case for
// the Nanode circuit board.
//
// @@TODO include generic stuff by reference rather than value as now
//


// Nanode board:
nanode_length   = 72.5;
nanode_width    = 58;
nanode_hole_dia = 3;
nanode_nut_af   = 5.5;
nanode_nut_ht   = 3;
nanode_nut_sd   = 8;
nanode_nut_sh   = 4;

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

// Other parameters
delta = 0.1;
spacing = 5;

//

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

module supportwithnut(dl, dw, sh, sd, nsh, nsd, delta)
{
  // Includes wider base for nut hole.
  translate([dl, dw, delta])
    union()
    { 
      cylinder(h=sh-delta, r=sd/2, $fa=30);
      cylinder(h=nsh-delta, r=nsd/2, $fa=30);
    }
}

module screwnuthole(l,sd,hd,nd,nh)
{
  // Screw hole with countersink at top and nut hole at bottom
  // Over-length to avoid manifold surface problems
  delta = 5;
  translate([0,0,-delta])
  {
    cylinder(h=l+delta*2, r=sd/2, $fn=20);
    cylinder(h=nh+delta, r=nd/2/sin(60.0), $fn=6);
  }
  hh = hd/2+delta;
  translate([0,0,h-hh+delta])
    cylinder(h=hh, r1=0, r2=hh, $fn=20);
}

module case1(l, w, h, t)
{
  // @@TODO: parameterize properly
  translate([s,0,0])
  {
    box(l, w, h, t);
    support(t+g+nanode_hole_1_x, t+g+nanode_hole_1_y, h*0.5, 5.1, 2, t/2); 
    support(t+g+nanode_hole_2_x, t+g+nanode_hole_2_y, h*0.5, 5.1, 2, t/2); 
    support(t+g+nanode_hole_3_x, t+g+nanode_hole_3_y, h*0.5, 5.1, 2, t/2); 
    support(t+g+nanode_hole_4_x, t+g+nanode_hole_4_y, h*0.5, 5.1, 2, t/2); 
    support(t+g+nanode_hole_5_x, t+g+nanode_hole_5_y, h*0.5, 5.1, 2, t/2); 
    support(t+g+nanode_hole_6_x, t+g+nanode_hole_6_y, h*0.5, 5.1, 2, t/2); 
  };
  translate([-s-l, 0, 0])
    lid(l, w, t);
}

module nanode_case(l, w, h, t, sh, sd, nsh, nsd)
{
  translate([s,0,0])
  {
    // Box
    box(l, w, h, t);
    // + supports
    // - holes
  };
  translate([-s-l, 0, 0])
  {
    // Lid
    lid(l, w, t);
    // + supports
    // - holes
  };
}

// Try it out
t = 1;		// Wall thickness
g = 0.5;       // gap around PCB
l = nanode_length+2*t+g*2;		// Length
w = nanode_width+2*t+g*2;		// Width
h = 12;		// Height
s = spacing;	// Spacing

r = [0:5];
echo(r);
for (i = r) echo (i);

//difference()
//{
//  supportwithnut(0, 0, h*0.5, 5.1, 4, 8, delta);
//  screwnuthole(h, nanode_hole_dia, nanode_hole_dia*2, nanode_nut_af, nanode_nut_ht);
//}

//screwnuthole(h, nanode_hole_dia, nanode_hole_dia*2, nanode_nut_af, nanode_nut_ht);

//screwnuthole(10, 6, 12, 6, 4);

//case1(l, w, h, t);

//support(t+g+nanode_hole_1_x, t+g+nanode_hole_1_y, h*0.5, 5, 2, t/2); 
