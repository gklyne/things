// AwningBrace.scad

delta = 0.01 ;
clearance = 0.1 ;

module Ring(od, id, t) {
    // Circular ring
    //
    // od   = outside diameter
    // id   = inside diameter
    // t    = thickness
    //
    difference() {
        cylinder(d=od, h=t) ;
        translate([0,0,-delta])
            cylinder(d=id, h=t+2*delta) ;
    }
}

module Segment180(d, a1, a2, t) {
    // Circle segment in X-Y plane, centred on origin extending from angle a1 to a2, 
    // where angles are measured clockwise from +X axis, a2 <= a1+180 (modulo 360).
    // Thus, the resulting segment has a maximum angle of 180 degrees.
    //
    // d    = diameter
    // a1   = start angle
    // a2   = end angle
    // 
    rotate([0,0,a1]) {
        difference() {
            dplus = d+delta ;
            cylinder(d=d, h=t) ;
            translate([-dplus/2,-dplus,-delta])
                cube(size=[dplus, dplus, t+2*delta]) ;
            rotate([0,0,a2-a1]) {
                translate([-dplus/2,0,-delta])
                    cube(size=[dplus, dplus, t+2*delta]) ;
            }
        }
    }
}

module Segment270(d, a1, a2, t) {
    // Circle segment in X-Y plane, centred on origin extending from angle a1 to a2, 
    // where angles are measured clockwise from +X axis, and a2 <= a1+270 (modulo 360).
    // Thus, the resulting segment has a maximum angle of 270 degrees.
    //
    // d    = diameter
    // a1   = start angle
    // a2   = end angle
    // t    = thickness
    // 
    // NOTE: this is overly complicated: do not use.  Segment180 is good
    r     = d/2 ;
    rplus = r+delta ;
    ar1   = -90 ;                       // first rotation relative to a1
    ar4   = (a2-a1)%360 ;               // final rotation relative to a1
    ars   = (ar4-ar1)%360 ;             // Sweep angle for segment
    arc   = ars ? 360 - ars : 0 ;       // Sweep angle for cutout
    ar2   = ar1 - (1/3)*arc ;           // second rotation
    ar3   = ar1 - (2/3)*arc ;           // third rotation
    difference() {
        cylinder(d=d, h=t) ;
        for (ar=[ar1,ar2,ar3,ar4]) {
            rotate([0,0,a1+ar])
                translate([0,0,-delta])
                    cube(size=[rplus, rplus, t+2*delta]) ;
        }
    }
}

module Segment(d, a1, a2, t) {
    // Circle segment in X-Y plane, centred on origin extending from angle a1 to a2, 
    // where angles are measured clockwise from +X axis, sweep a range <360
    //
    // d    = diameter
    // a1   = start angle
    // a2   = end angle
    // t    = thickness
    // 
    amid = a1 < a2 ? (a1+a2)/2 : (a1+a2)/2 + 180 ;
    Segment180(d, a1, amid+delta, t) ;
    Segment180(d, amid-delta, a2, t) ;
}

module RingSegment(od, id, a1, a2, t) {
    // Ring segment in X-Y plane, centred on origin extending from angle a1 to a2, 
    // where angles are measured clockwise from +X axis, sweep a range <360
    //
    // od   = outrside diameter
    // id   = inside diameter
    // a1   = start angle
    // a2   = end angle
    // t    = thickness
    // 
    intersection() {
        Ring(od, id, t) ;
        Segment(od, a1, a2, t) ;
    }
}

module test_ring_segment() {
    translate([0,0,0])
        Ring(20, 15, 2) ;
    translate([25,0,0])
        Segment180(20, 30, 120, 2) ;
    translate([50,0,0])
        Segment180(20, 40, 150, 2) ;
    translate([75,0,0])
        Segment180(20, 200, 330, 2) ;
    translate([100,0,0])
        Segment180(20, 30, 60, 2) ;

    translate([25,25,0])
        Segment180(20, 30, 120, 2) ;
    translate([50,25,0])
        Segment270(20, 40, 150, 2) ;
    translate([75,25,0])
        Segment270(20, 200, 330, 2) ;
    translate([100,25,0])
        Segment270(20, 30, 60, 2) ;
    translate([125,25,0])
        Segment270(20, 30, 300, 2) ;

    translate([25,50,0])
        Segment(20, 30, 120, 2) ;
    translate([50,50,0])
        Segment(20, 40, 150, 2) ;
    translate([75,50,0])
        Segment(20, 200, 330, 2) ;
    translate([100,50,0])
        Segment(20, 30, 60, 2) ;
    translate([125,50,0])
        Segment(20, 30, 330, 2) ;
    translate([150,50,0])
        Segment(20, 30, -30, 2) ;
    translate([175,50,0])
        Segment(20, -150, 150, 2) ;
    translate([200,50,0])
        Segment(20, 60, 30, 2) ;
   translate([225,50,0])
        Segment(20, -30, -60, 2) ;

    translate([25,75,0])
        RingSegment(20, 15, 30, 330, 2) ;
    translate([50,75,0])
        RingSegment(20, 15, 210, 150, 2) ;
    translate([75,75,0])
        RingSegment(20, 15, 210, 360+150, 2) ;
    translate([100,75,0])
        RingSegment(20, 15, 45, -45, 2) ;
}
// test_ring_segment() ;


module Contact_pad(l, w, t) {
    // Contact pad on X-Y plane, centred on Origin
    difference() {
        translate([0,0,t/2])
            cube(size=[l,w,t], center=true) ;
        translate([-l/2-t,0,t*0.75])
            rotate([0,40,0])
                cube(size=[t*2,w*2,t*4], center=true) ;
        translate([l/2+t,0,t*0.75])
            rotate([0,-40,0])
                cube(size=[t*2,w*2,t*4], center=true) ;
    }
}
//Contact_pad(20, 5, 5) ;

module Contact_pad_y(l, w, t, dir=+1)
    rotate([-90*dir,0,0])
        Contact_pad(l, w, t) ;

//translate([-75+10, -75-delta, 12.5/2])
//    Contact_pad_y(20, 12.5, 5, +1) ;


module Contact_pad_x(l, w, t, dir=+1)
    rotate([0,90*dir,0])
        rotate([0,0,90])
            Contact_pad(l, w, t) ;
//Contact_pad_x(20, 12.5, 5, -1) ;



module Awning_brace(jaw_w, jaw_l, rad_t, wid, pad_l, pad_t) {
    od = jaw_w + rad_t*2 ;
    // Back of clamp
    RingSegment(od, jaw_w, -90, 90, wid) ;
    // Jaw arms
    for (y=[-(jaw_w+rad_t)/2,(jaw_w+rad_t)/2]) {
        translate([-jaw_l, y-rad_t/2, 0])
            cube(size=[jaw_l+delta, rad_t, wid]) ;
    }
    // Contact pads
    translate([-jaw_l+pad_l/2, -jaw_w/2-delta, wid/2])
        Contact_pad_y(pad_l, wid, pad_t, +1) ;
    translate([-jaw_l+pad_l/2, +jaw_w/2+delta, wid/2])
        Contact_pad_y(pad_l, wid, pad_t, -1) ;
    translate([0, -jaw_w/2-delta, wid/2])
        Contact_pad_y(pad_l, wid, pad_t, +1) ;
    translate([0, +jaw_w/2+delta, wid/2])
        Contact_pad_y(pad_l, wid, pad_t, -1) ;

    translate([+jaw_w/2+delta, 0, wid/2])
        Contact_pad_x(pad_l, wid, pad_t, -1) ;
    // Clamp piece
}

Awning_brace(jaw_w=150, jaw_l=75, rad_t=10, wid=5, pad_l=20, pad_t=5) ;






