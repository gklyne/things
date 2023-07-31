// HedgehogClip.scad
//
// Gutter clip for retaining a "hedgehog" debris-repelling filler.
// Inspired by a wire-based design by David Postoern.
//

delta         = 0.01 ;
clearance     = 0.1 ;

gulley_w      = 50 ;
gulley_edge_w = 10 ;   
clip_w        = 8 ;
clip_t        = 2 ;
clip_l        = gulley_w + gulley_edge_w ;
clip_tbar_w   = 25 ;                // Width of T-bar end
clip_tbar_d   = gulley_edge_w ;     // Depth of T-bar end
clip_tbar_t0  = 1 ;                 // Thickness of T-bar thin end
retainer_w    = 12 ;                // Width of retainer
retainer_d    = 6 ;                 // Depth of retainer
retainer_lip  = 1 ;                 // Width/thickness of retainer lip

module trapezoid_45_prism(l, w, t) {
    // Trapezoidal prism with 45-degree faces, centred on and extending along X-axis.
    //
    // l = length of prism
    // w = width of wide face of prism
    // t = thickness of prism
    //
    difference() {
        // Body:
        translate([0,-w/2,0])
            cube(size=[l,w,t], center=false) ;
        // 45 degree chamfers:
        translate([-delta,-w/2,0])
            rotate([45,0,0])
                cube(size=[l+delta*2,t*2,t*2], center=false) ;
        translate([-delta,+w/2,0])
            rotate([45,0,0])
                cube(size=[l+delta*2,t*2,t*2], center=false) ;
    }
}
////-Test trapezoid_45_prism(l, w, t)
// trapezoid_45_prism(100, 10, 2) ;

module wedge(l,w,t0,t1) {
    // Wedge with edge lying on and extending on the X-axis, 
    // tapering along the Y axis.
    //
    // l  = length of wedge
    // w  = width of wedge
    // t0 = thickness of wedge at X-axis (y=0)
    // t1 = thickness of wedge away from X-axis (y=w)
    //
    difference() {
        // Body:
        translate([0,0,0])
            cube(size=[l,w,t0+t1], center=false) ;
        // Taper:
        translate([0,0,t0])
            rotate([atan2(t1-t0,w),0,0])
                translate([-delta,-delta,0])
                    cube(size=[l+delta*2,w+t0+t1,t0+t1], center=false) ;
    }
}
////-Test wedge(l,w,t0,t1)
// wedge(100,10,2,1) ;
// wedge(20,2,2,0) ;

module clip_main_part(tbar_w,tbar_d,tbar_t0,clip_l,clip_w,clip_t) {
    // Main clip as T-piece
    rotate([0,0,-90])
        translate([-tbar_w/2,0,0])
            wedge(tbar_w, tbar_d, tbar_t0, clip_t) ;
    translate([tbar_d-delta,0,0])
        trapezoid_45_prism(clip_l-tbar_d, clip_w, clip_t) ;
}
////-Test clip_main_part(tbar_w,tbar_d,tbar_t0,clip_l,clip_w,clip_t)
clip_main_part(clip_tbar_w, clip_tbar_d, clip_tbar_t0, clip_l, clip_w, clip_t) ;


module clip_retainer() {
    difference() {
        union() {
            translate([-retainer_d+delta,-retainer_w/2,0])
                cube(size=[retainer_d, retainer_w, clip_t*2+retainer_lip], center=false) ;
            translate([-delta,retainer_w/2,clip_t*2+retainer_lip])
                rotate([-90,0,-90])
                    wedge(retainer_w, retainer_lip, retainer_lip, 0) ;
            translate([0,-clip_w/2,0])
                cube(size=[gulley_edge_w+retainer_lip, clip_w, clip_t], center=false) ;
            translate([gulley_edge_w,clip_w/2,clip_t-delta])
                rotate([0,0,-90])
                    wedge(clip_w, retainer_lip, retainer_lip, 0) ;
        }
        translate([-retainer_d-delta,0,clip_t])
            rotate([0,0,0])
                trapezoid_45_prism(
                    retainer_d+retainer_lip+delta, 
                    clip_w+clearance*2, 
                    clip_t+retainer_lip+delta
                ) ;
    }
}
////-Test clip_retainer()
translate([clip_l+clip_w,0,-clip_t]) clip_retainer() ;
