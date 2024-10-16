// CampingChairFeet.scad

include <common-components.scad> ;

// delta     = 0.01 ;
// clearance = 0.3 ;

// Rounded cylinder
module rounded_cylinder(d, h) {
    // Centred on X-Y plane origin, rounded end on +Z axis
    // h is height to centre of rounded end
    difference() {
        union() {
            cylinder(d=d, h=h, $fn=24) ;
            translate([0,0,h])
                sphere(d=d, $fn=24) ;        
        }
        translate([0,0,-d/2])
            cube(size=[d,d,d], center=true) ;
    }
}
////-rounded_cylinder(d, h)
//// rounded_cylinder(20,10) ;

// Pointed cylinder
module pointed_cylinder(d, h) {
    // Centred on X-Y plane origin, rounded end on +Z axis
    // h is height to centre of cone of pointed end
    cylinder(d=d, h=h, $fn=24) ;
    translate([0,0,h])
        cylinder(d1=d, d2=0, h=d, $fn=24) ;        
}
////-pointed_cylinder(d, h)
//// pointed_cylinder(20,10) ;

// Rounded cutout
module rounded_cutout(l, w, t) {
    // Cutout centered on origin, rounded end down
    // length extending horizontally on X axis
    //
    // l    = length of cutout
    // w    = width of cutout
    // t    = thickness of cutout (= diameter of rounded end)
    //
    rotate([0,-90,0]) {
        translate([w/2,0,0])
            cube(size=[w,t,l], center=true) ;
        cylinder(d=t, h=l, $fn=16, center=true) ;
    }
}
////-rounded_cutout(l, w, t)-
//// translate([-20,0,0])
////     rounded_cutout(20, 10, 5) ;

// Extruded cruciform
module cruciform(d, l, w) {
    // Centred on origin, extending along +Z axis
    //
    // d    = overall diameter
    // l    = overall length
    // w    = width of cruciform arms
    //
    translate([0,0,l/2]) {
        cube(size=[d,w,l], center=true) ;
        cube(size=[w,d,l], center=true) ;
    }
}

// Leg-fitting cutout
module leg_fitting_socket(d, l) {
    difference() {
        cylinder(d=d+clearance*8, h=l, $fn=24) ;
        translate([0,0,-delta]) {
            difference() {
                cruciform(d+clearance*10, l+delta*2, 2) ;
                translate([0,0,-delta*2])
                    cylinder(d1=d+clearance*4, d2=d+clearance*1, h=l+delta*4, $fn=24) ;
            }
        }
    }
    translate([0,0,l-delta])
        cylinder(d1=d, d2=0, h=d/2, $fn=24) ;
}
////-leg_fitting_socket(d, l)-
//// translate([0,50,0])
////     leg_fitting_socket(14, 20) ;


// Ball joint - ball
module ball_joint_ball(d, bt, sd, sh) {
    // Base on X-Y plane origin, ball on Z-axis
    //
    // d    = diameter of ball
    // bt   = thickness of base
    // sd   = diameter of stalk
    // sh   = height of stalk
    //    
    // Base
    cylinder(d=d, h=bt, $fn=24 ) ;
    // Stalk
    cylinder(d=sd, h=sh+bt+d/2, $fn=16 ) ;
    // Ball
    translate([0,0,d/2+bt+sh])
        sphere(d=d, $fn=24) ; 
}
////-ball_joint_ball(d, t)
//// translate([40,0,22])
////     mirror([0,0,1])
////         ball_joint_ball(20, 2, 20*0.5, 2) ;
//// translate([80,0,0])
////     ball_joint_ball(20, 2, 20*0.5, 2) ;

// Ball joint - ball, with inner hollowed for stronger build (inner wall)
module ball_joint__ball_hollowed(d, bt, sd, sh) {
    difference() {
        ball_joint_ball(d, bt, sd, sh) ;
        translate([0,0,-delta])
            rounded_cylinder(sd*0.5, sh) ;
    }
}
////-ball_joint__ball_hollowed(d, bt, sd, sh)-
//// translate([40,0,0])
////     ball_joint__ball_hollowed(20, 2, 20*0.5, 2) ;

// Ball joint - socket
module ball_joint_socket(d, bt, st, sh, cw) {
    // Base on X-Y plane origin, ball on Z-axis
    //
    // d    = diameter of ball
    // bt   = thickness of base
    // st   = thickness of socket wall
    // sh   = height of socket centre above base
    // cw   = width of cutouts
    //
    sd = d+2*st ;   // Diameter of socket outer housing
    difference() {
        pointed_cylinder(sd, sh+bt) ;   
        //rounded_cylinder(sd, sh+bt) ;
        // translate([0,0,-delta])
        //     rounded_cylinder(d, sh+bt+delta) ;   // Hollow out inside
        translate([0,0,sh])
            sphere(d=d, $fn=24) ;                   // Ball socket
        translate([0,0,sh+d*0.5])
            sphere(d=d, $fn=24) ;                   // Flare entry
        translate([-sd/2,-sd/2,sh+bt+d*0.2])
            cube(size=[sd,sd,sd]) ;                 // Remove top of socket
        translate([0,0,sh]) {
            rotate([0,0,0])
                rounded_cutout(sd+2*delta, sd, cw) ;
            rotate([0,0,90])
                rounded_cutout(sd+2*delta, sd, cw) ;
        }
    }
}
////-ball_joint_socket(d, bt, st, sh, sd)-
//// ball_joint_socket(20, 2, 2, 10, 5) ;

// Ball end with leg fitting and hole for reinforcing screw
module ball_end_fitting(d, bt, sd, sh, fl, fd, ft) {
    // Base on X-Y plane origin, ball on Z-axis
    //
    // d    = diameter of ball
    // bt   = thickness of base
    // sd   = diameter of stalk
    // sh   = height of stalk
    // fl   = length of fitting over leg
    // fd   = leg fitting hole diameter
    // ft   = thickness of fitting over leg
    //
    rsd  = m3 ;             // Reinforcing screw diameter
    rsaf = m3_nut_af ;      // Reinforcing screw nut A/F
    rst  = m3_nut_t ;       // Reinforcing screw nut thickness
    rspr = d/2+rsaf/2 ;     // Reinforcing screws pitch circle radius
    difference() {
        union () {
            // Ball and stalk
            translate([0,0,fl])
                ball_joint_ball(d, bt, sd, sh) ;
            // Sleeve to Fit over chair leg
            translate([0,0,0])
                cylinder(d=fd+2*ft, h=fl+bt, $fn=24) ;
            // Outer housing for reinforcing screw
            for ( a=[0,120,240] ) {
                rotate([0,0,a]) {
                    translate([rspr,0,0])
                        cylinder(d=rsd*2.5, h=fl+bt, $fn=16) ;                
                }
            }
        }
        // Remove ribbed hole for fitting over leg
        translate([0,0,-bt-1])
            leg_fitting_socket(fd, fl) ;
        // Hole for reinforcing screw and countersink head
        translate([0,0,fl-1])
            mirror([0,0,1])
                countersinkZ(rsd*2, fl+bt+sh+d, rsd, fl+delta) ;
        // Top recess for nut
        translate([0,0,fl+bt+sh+d*0.7])
            nut_recess_Z(rsaf+clearance, d*0.3) ;
        // Holes for fitting reinforcement screws
        translate([0,0,0]) {
            for ( a=[0,120,240] ) {
                rotate([0,0,a]) {
                    translate([rspr,0,fl+bt+delta])
                        // module countersinkZ(od, oh, sd, sh)
                        countersinkZ(rsd*2, fl+bt+2*delta, rsd, fl+bt) ;
                    translate([rspr,0,-delta])
                        rotate([0,0,30])
                        nut_recess_Z(rsaf+clearance, rst*1.5) ;
                }
            }
        }
    }
}


// Foot plate with ball joint to swivel on ball end of chair leg
module ball_socket_foot_plate(d, bt, st, sh, cw, fd) {
    // Base on X-Y plane origin, ball on Z-axis
    //
    // d    = diameter of ball
    // bt   = thickness of base
    // st   = thickness of socket wall
    // sh   = height of socket centre above base
    // cw   = width of cutouts
    // fd   = diameter of foot plate
    //
    ball_joint_socket(d, bt, st, sh, cw) ;
    difference() {
        cylinder(d=fd, h=bt, $fn=24) ;
        translate([0,0,-delta])
            cylinder(d=d, h=bt+2*delta, $fn=24) ;
    }
    // Support webbing...
    for( a = [0+45,90+45,180+45,270+45]) {
        rotate([0,0,a]) {
            translate([d*0.5+st*0.5,0,bt-delta])
                rotate([90,0,0])
                    web_base((fd-d)*0.5-st, sh+d*0.2, bt) ;
        }
    }
}


// Simple cap end for chair leg
// (Used for shower stool feet)
module cap_end(fl, fd, ft) {
    // Base on X-Y plane origin, ball on Z-axis
    //
    // fl   = length of fitting over leg
    // fd   = leg fitting hole diameter
    // ft   = thickness of fitting over leg
    //
    difference() {
        union () {
            // Sleeve to Fit over chair leg
            translate([0,0,0])
                cylinder(d=fd+2*ft, h=fl, $fn=24) ;
            // Rounded end
            translate([0,0,fl])
                sphere(d=fd+6*ft, $fn=24) ;
        }
        // Remove ribbed hole for fitting over leg
        translate([0,0,-delta])
            leg_fitting_socket(fd, fl) ;
        }
}
////-cap_end(bt, fl, fd, ft)-
//// cap_end(25, 19, 2) ;

////-ShowerStoolFeet-
for ( xo = [-40,0,40] ) {
    translate([xo, 0, 0])
        cap_end(25, 19, 2) ;    
}


// Print objects

ball_d  = 15 ;              // Diameter of ball/socket
base_t  = 3 ;               // Thickness of socket base (foot)
stalk_d = ball_d*0.55 ;     // Diameter of ball stalk
sock_t  = 2.8 ;             // Thickness of ball socket shell
fit_l   = 22 ;              // Length of ball end fitting over leg
fit_d   = 12.5 ;            // Inside diameter ball end fitting over leg
fit_t   = 3 ;             // Thickness of ball end fitting over leg
foot_d  = 52 ;              // Diameter of foot

// ball_joint_socket(ball_d, base_t, sock_t, ball_d/2, stalk_d+0.5) ;
// translate([ball_d*2,0,0])
//     ball_joint__ball_hollowed(ball_d-clearance, base_t, stalk_d, base_t) ;

// ball_socket_foot_plate(ball_d, base_t, sock_t, ball_d/2+base_t/2, stalk_d+0.1, foot_d) ;
// translate([foot_d,0,0])
//     ball_end_fitting(ball_d, base_t, stalk_d, base_t, fit_l, fit_d, fit_t) ;

