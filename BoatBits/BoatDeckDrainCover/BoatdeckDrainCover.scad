// Boat deck drain cover

hole_r   = 51;     // Radius of hole
hole_h   = 62;     // Height of hole
hole_t   = 6;      // Thickness of hole (through hull plate)
cover_t  = 10;     // Overall thickness of hole+cover
flange_r = 56;     // Radius of cover (flange)
clip_t   = 3;      // Thickness of clips
clip_w   = 10;     // Width of clip at top
clip_h   = 6;      // height of clips over hole
hook_t   = 5;

hole_r   = 50;
hole_h   = 60;
hole_t   = 6;
cover_t  = 10;
flange_r = 55;
clip_t   = 3;
clip_w   = 10;
clip_h   = 6;
hook_t   = 5;

module fillet_yz(fy, fz, ft, py)
{
  translate([-ft/2,py-fy,0])
    intersection()
    {
      rotate([atan(fz/fy),0,0])
        translate([0,0,-fz])
          cube([ft,fy+fz,fz]);
    cube([ft,fy,fz]);
    }
}

module cover_inner_cylinder()
{
  difference()
  {
    cylinder(r=hole_r,h=cover_t+clip_h,$fn=64);
    translate([0,0,-1])
      cylinder(r=hole_r-clip_t,h=cover_t+clip_h+2,$fn=64);
  }
}

module cover_flap()
{
  difference()
  {
    // Flanged disk
    union()
    {
      cylinder(r=hole_r,h=cover_t,$fn=64);
      cylinder(r=flange_r,h=cover_t-hole_t,$fn=64);
    }
    // Leave jusyt hollow cylinder in hole
    translate([0,0,cover_t-hole_t])
    {
      difference()
      {
        cylinder(r=hole_r-clip_t,h=cover_t,$fn=64);
        //cylinder(r=(hole_r-clip_t)-(flange_r-hole_r),h=cover_t);
      }
    }
    // Cut away bottom of disk
    union()
    {
      translate([hole_h-hole_r,-flange_r,cover_t-hole_t])
        cube([flange_r, flange_r*2, cover_t*2]);
      translate([(hole_h-hole_r)+(flange_r-hole_r),-flange_r,-cover_t*0.5])
        cube([flange_r, flange_r*2, cover_t*2]);
    }
  }
}

module cover_clip(a)
{
  ha = asin((hook_t-clip_t)/clip_h);
  hd = 1;
  rotate([0,0,a])
  {
    // Clip shape
    intersection()
    {
      cover_inner_cylinder();
      translate([-clip_w*0.5,hole_r-clip_t*1.5,0])
      {
        cube([clip_w,clip_t*2,cover_t+clip_h]);  // Main peg
        translate([0,0,cover_t+clip_h])
          rotate([0,45,0])
            translate([0,0,-cover_t])
              cube([clip_w,clip_t*2,cover_t]);
        translate([clip_w,0,cover_t+clip_h])
          rotate([0,-45,0])
            translate([-clip_w,0,-cover_t])
              cube([clip_w,clip_t*2,cover_t]);
      }
    }
    // Clip lip
    translate([-clip_w*0.5,hole_r-clip_t,0])
      translate([0,0,cover_t+clip_h])
        rotate([ha,0,0])
          translate([0,0,-(clip_h+hd)])
            difference()
            {
              cube([clip_w,clip_t,clip_h+hd]);
              translate([-1,0,0])
                rotate([-45-ha,0,0])
                  cube([clip_w+2,clip_t,clip_h]);
            }
    // Supporting fillet
    fillet_yz((cover_t+clip_h)*2, (cover_t+clip_h), clip_t, hole_r);
  }
}

module cover()
{
  cover_flap();
  cover_clip(5);
  cover_clip(60);
  cover_clip(120);
  cover_clip(175);
}

cover();

//cover_clip(0);







//translate([-clip_t/2,0,0])
//  cube([clip_t,(cover_t+clip_h)*2,cover_t+clip_h]);


