// LightPullToggle.scad

delta = 0.01 ;

module truncated_cone(d, h, tt, tb, $fn=32) {
    // Truncated cone on X-Y plane, centred on Z axis
    //
    // The diameter and height parameters define the slope of the sides, 
    // and top and bottom truncation parameters define the overall size
    //
    th = h - tt - tb ;  // Height of truncated cone
    intersection() {
        translate([0,0,-tb]) {
            cylinder(d1=d, d2=0, h=h, $fn=$fn) ;
        }
        translate([0,0,th/2]) {
            cube(size=[d,d,th], center=true) ;
        }
    }
}
////-truncated_cone(d, h, tt, tb, $fn=32)
//-truncated_cone(d=20, h=25, tt=5*(25/20), tb=4) ;


module truncated_cone_shell(d, h, t, tt, tb) {
    // Truncated conic shell on X-Y plane, centred on Z axis
    //
    // d  = diameter at base of cone
    // h  = height to apex (point) of cone
    // t  = thickness of shell
    // tt = truncation at top of code (gives flat top)
    // tb = truncation at base of code (reduces overall height while preserving slope)
    //
    slope_a = atan2(d/2, h) ;       // Half angle at apex
    shift_z = t / sin(slope_a) ;    // Shift down to leave desired shell thickness
    difference() {
        truncated_cone(d=d, h=h, tt=tt, tb=tb) ;
        translate([0,0,-shift_z]) {
            truncated_cone(d=d, h=h, tt=tt, tb=tb) ;
        }
    }
}
////-truncated_cone_shell(d, h, t, tt, tb, $fn=32)
//truncated_cone_shell(d=20, h=25, t=1, tt=5*(25/20), tb=4) ;

module LightPullToggle(d1, d2, h, t, cd) {
    // Conic shell with hole for light-pull cord toggle
    //
    // d1 = diameter at base
    // d2 = diameter at top
    // h  = overall height
    // t  = thickness of shell
    // cd = cord hole diameter
    //
    ha = h * (1+d2/d1) ;        // Height of notional apex of cone
    difference() {
        truncated_cone_shell(d=d1, h=ha, t=t, tt=ha-h, tb=0) ;
        cylinder(d=cd, h=ha, $fn=8) ;
        }
}
////-LightPullToggle(d1, d2, h1, h2, t, cd)
LightPullToggle(d1=25, d2=5, h=25, t=1, cd=3) ;

module LightPullCordLock(d1, d2, h, t1, t2, cd) {
    // Insert for light pull toggle to hold and lock cord in place
    //
    // Parameters are dimensions for toggle into which the locking piece fits.
    // The insert is shortened by 2mm at apex, and 4mm at base to fit inside.
    //
    // d1 = diameter at base
    // d2 = diameter at top
    // h  = overall height
    // t1 = thickness of toggle outer shell
    // t2 = thickness of locking piece shell
    // cd = cord hole diameter
    //
    ha      = h * (1+d2/d1) ;       // Height of notional apex of cone
    slope_a = atan2(d1/2,ha) ;      // Half angle at apex
    shift_z = t1 / sin(slope_a) ;   // Shift down to fit inside desired shell thickness
    hl      = h - 2 - shift_z - 4 ;
    hla     = h - shift_z ;         // Height of notional locking piece apex
    dl_half = hla*sin(slope_a) ;    // Half diameter at base of locking piece
    difference() {
        truncated_cone_shell(d=d1, h=ha, t=t2, tt=ha-h+2, tb=shift_z+4) ;
            // Cross holes
            translate([0,0,hl*0.65])
                rotate([0,90,0])
                    cylinder(d=cd,h=d1,center=true,$fn=8) ;
            translate([0,0,hl*0.4])
                rotate([0,90,0])
                    cylinder(d=cd,h=d1,center=true,$fn=8) ;
            translate([0,0,hl*0.15])
                rotate([0,90,0])
                    cylinder(d=cd,h=d1,center=true,$fn=8) ;
            // Grooves for cord
            rotate([0,-slope_a,0])
                translate([dl_half,0,0])
                    cylinder(d=cd,h=2*h+d1,center=true, $fn=8) ;
            rotate([0,slope_a,0])
                translate([-dl_half,0,0])
                    cylinder(d=cd,h=2*h+d1,center=true, $fn=8) ;
    }
}

////-LightPullCordLock(d1, d2, h, cd)
translate([0*30,0,0]) LightPullCordLock(d1=25, d2=5, h=25, t1=1, t2=3, cd=3) ;

