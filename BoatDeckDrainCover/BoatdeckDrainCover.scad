// Boat desck drain cover

hole_r   = 51;
hole_h   = 62;
hole_t   = 6;
cover_t  = 10;
flange_r = 56;
clip_t   = 3;
clip_w   = 10;
clip_h   = 6;
hook_t   = 5;

module cover_inner_cylinder()
{
  difference()
  {
    cylinder(r=hole_r,h=cover_t+clip_h,$fn=64);
    cylinder(r=hole_r-clip_t,h=cover_t+clip_h,$fn=64);
  }
}

module cover_flap()
{
  difference()
  {
    union()
    {
      cylinder(r=hole_r,h=cover_t,$fn=64);
      cylinder(r=flange_r,h=cover_t-hole_t,$fn=64);
    }
    translate([0,0,cover_t-hole_t])
    {
      difference()
      {
        cylinder(r=hole_r-clip_t,h=cover_t,$fn=64);
        //cylinder(r=(hole_r-clip_t)-(flange_r-hole_r),h=cover_t);
      }
    }
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
  }
}

module cover()
{
  cover_flap();
  cover_clip(0);
  cover_clip(60);
  cover_clip(120);
  cover_clip(180);
}

cover();

//cover_clip(0);

