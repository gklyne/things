// HedgehogClip_2.scad
//
// Gutter clip for retaining a "hedgehog" debris-repelling filler.
// Inspired by a wire-based design by David Poston.
//
// Take 2 with narrower, triangular cross piece
//

delta         = 0.01 ;
clearance     = 0.1 ;

gulley_w      = 50 ;
gulley_edge_w = 10 ;   
clip_tw       = 3 ;                 // Width of cross-piece triangle
clip_ta       = 0.6 ;               // Width of triangle apex (non-zero for printing)
clip_th       = 8 ;                 // Height of cross-piece triangle
clip_l        = gulley_w + gulley_edge_w ;
clip_tbar_w   = 25 ;                // Width of T-bar end
clip_tbar_d   = gulley_edge_w/2 ;   // Depth of T-bar end
clip_tbar_t0  = 1 ;                 // Thickness of T-bar thin end
clip_tbar_t   = 2 ;                 // Thickness of T-bar thick end
retainer_w    = 7 ;                 // Width of retainer
retainer_d    = 8 ;                 // Depth of retainer
retainer_t    = 2 ;                 // Thickness of retainer cross-bar
retainer_lip  = 1 ;                 // Width/thickness of retainer lip


module triangular_prism(l, w, h) {
    // Triangular prism, centred on and extending along X-axis,
    // with the apex down
    //
    // l = length of prism
    // w = width of base of prism
    // h = height from base to apex of prism
    //
    // NOTE: this can be constructed as a degenerate form of "symmetric_trapezoid"
    //
    rotate([0,90,0]) {
        linear_extrude(height=l) {
            polygon(
                points=[
                    [0,0], 
                    [-h, -w/2], 
                    [-h, +w/2], 
                    ],
                paths=[[0,1,2,0]]
            ) ;
        }
    }
}
////-Test triangular_prism(l, w, h)
// triangular_prism(50, 3, 8) ;


module symmetric_trapezoid(l, w1, w2, h) {
    // Symmetric tapered cuboid lying on X-Y plane, extending from origin along X-axis
    //
    // l    = overall length (X-dimension)
    // w1   = width of edge lying on X-Y plane
    // w2   = width of edge above X-Y plane
    // h    = height (Z-dimension)
    //
    rotate([0,90,0]) {
        linear_extrude(height=l) {
            polygon(
                points=[
                    [ 0,-w1/2], 
                    [-h,-w2/2], 
                    [-h,+w2/2], 
                    [0, +w1/2],
                    ],
                paths=[[0,1,2,3,0]]
            ) ;
        }
    }
}
////-Test symmetric_trapezoid(l, w1, w2, t)
// symmetric_trapezoid(50, 2, 4, 8) ;

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

module clip_main_part(tbar_w, tbar_d, tbar_t, tbar_t0, clip_l, clip_w, clip_a, clip_h) {
    rotate([0,0,-90])
        translate([-tbar_w/2,0,0])
            wedge(tbar_w, tbar_d, tbar_t0, tbar_t) ;
    translate([tbar_d-delta,0,0])
        symmetric_trapezoid(tbar_t, clip_w*3, clip_w, clip_h) ;
    translate([tbar_d-delta,0,0])
        symmetric_trapezoid(clip_l-tbar_d, clip_a, clip_w, clip_h) ;
}
////-Test clip_main_part(tbar_w,tbar_d,tbar_t0,clip_l,clip_w,clip_t)
clip_main_part(clip_tbar_w, clip_tbar_d, clip_tbar_t, clip_tbar_t0, clip_l, clip_tw, clip_ta, clip_th) ;


retainer_slider_h = clip_th+retainer_t*2 ;

module clip_retainer() {
    difference() {
        union() {
            // Retaining clip slider body
            translate([-retainer_d+delta,-retainer_w/2,0])
                cube(size=[retainer_d, retainer_w, retainer_slider_h], center=false) ;
            // Retaining clip gulley edge hook
            translate([-delta,retainer_w/2,0])
                rotate([0,0,-90])
                    wedge(retainer_w, retainer_lip, retainer_lip, 0) ;

            // Retaining clip positioning arm
            translate([0,-retainer_w/2,retainer_slider_h-retainer_t])
                cube(size=[gulley_edge_w+retainer_lip, retainer_w, retainer_t], center=false) ;
            translate([gulley_edge_w,retainer_w/2,retainer_slider_h-retainer_t+delta])
                rotate([-90,0,-90])
                    wedge(retainer_w, retainer_lip, retainer_lip, 0) ;
        }
        translate([-retainer_d-delta,0,retainer_t-clearance*2])
            rotate([0,0,0])
                symmetric_trapezoid(
                    retainer_d+retainer_lip+delta, 
                    clip_ta+clearance*2, 
                    clip_tw+clearance*2, 
                    clip_th+clearance*2
                    ) ;
                ////trapezoid_45_prism(
                ////    retainer_d+retainer_lip+delta, 
                ////    clip_w+clearance*2, 
                ////    clip_t+retainer_lip+delta
                ////) ;
    }
}
////-Test clip_retainer()
// For assembly viewing:
translate([clip_l+clip_tbar_d+5,0,-retainer_t]) clip_retainer() ;
// For printing with common baseline and no overhang
// translate([clip_l+clip_tbar_d+5,0,retainer_slider_h]) mirror([0,0,1]) clip_retainer() ;
