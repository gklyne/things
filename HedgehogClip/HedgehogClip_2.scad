// HedgehogClip_2.scad
//
// Gutter clip for retaining a "hedgehog" debris-repelling filler.
// Inspired by a wire-based design by David Poston.
//
// Take 2 with narrower, triangular cross piece
//

delta           = 0.01 ;
clearance       = 0.16 ;

gulley_w        = 80 ;
gulley_edge_w   = 12 ;   
clip_tw         = 4 ;                   // Width of cross-piece triangle
clip_ta         = 1.0 ;                 // Width of triangle apex (non-zero for printing)
clip_th         = 8 ;                   // Height of cross-piece triangle
clip_l          = gulley_w + gulley_edge_w ;
clip_tbar_w     = 25 ;                  // Width of T-bar end
clip_tbar_d     = gulley_edge_w/2+2 ;   // Depth of T-bar end
clip_tbar_t0    = 1 ;                   // Thickness of T-bar thin end
clip_tbar_t     = 2 ;                   // Thickness of T-bar thick end
retainer_w      = 8 ;                   // Width of retainer
retainer_d      = 10 ;                  // Depth of retainer
retainer_t      = 1.5 ;                 // Thickness of retainer cross-bar
retainer_lip    = 2.4 ;                 // Width/thickness of retainer lip
retainer_gap    = 2.0 ;                 // Gap between edge and cross-piece
retainer_catch  = retainer_lip/2 ;      // Size of retainer end catch 
retainer_tooth  = 1.0 ;                 // Size of retainer teeth
retainer_pitch  = retainer_tooth*1.25 ;  // Pitch of retainer teeth

// Supporting shape definitions

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


module sawtooth_rack(l, w, t, th, tw, tp) {
    // Sawtooth rack centred on +ve X-axis.
    // Teeth are on upper side, with vertical edge facing towards -X, and 45-degree slope facing +X.
    // Bottom of teeth are on X-Y plane.
    //
    // Note: 
    //  tp > tw spaces teeth apart, allowing room for the teeth to drop in the gaps
    //  tw > th gives flattened tops, suitable for subtraction to create spaced-out teeth
    //
    // l = overall length of rack
    // w = width of rack
    // t = thickness of rack, not including teeth
    // th = height of teeth
    // tw = width of teeth
    // tp = pitch of teeth
    //
    nt = floor(l/tp) ;   // Number of teeth
    translate([0,-w/2,-t])
        cube(size=[l,w,t]) ;
    intersection() {
        for (n = [0:nt-1]) {
            translate([l-tw-n*tp,w/2,-delta])
               rotate([0,0,-90])
                   wedge(w, tw, tw, 0) ;
        }
        translate([-delta,-w/2,-delta])
            cube(size=[l,w,th]) ;                       
    }
}
////-Test sawtooth_rack(l, w, t, th, tp)
//sawtooth_rack(15, 5, 1, 1, 1, 1.5) ;
//sawtooth_rack(15, 5, 1, 1, 1.5, 1.5) ;


// Hedgehog clip definition

module clip_main_part(tbar_w, tbar_d, tbar_t, tbar_t0, clip_l, clip_w, clip_a, clip_h) {
    rotate([0,0,-90])
        translate([-tbar_w/2,0,0])
            wedge(tbar_w, tbar_d, tbar_t0, tbar_t) ;
    translate([tbar_d-tbar_t,0,0])
        symmetric_trapezoid(tbar_t, clip_w*3, clip_w, clip_h) ;
    translate([tbar_d-delta,0,0])
        symmetric_trapezoid(clip_l-tbar_d, clip_a, clip_w, clip_h) ;
}
////-Test clip_main_part(tbar_w,tbar_d,tbar_t0,clip_l,clip_w,clip_t)
//clip_main_part(clip_tbar_w, clip_tbar_d, clip_tbar_t, clip_tbar_t0, clip_l, clip_tw, clip_ta, clip_th) ;


module clip_main_toothed(tbar_w, tbar_d, tbar_t, tbar_t0, clip_l, clip_w, clip_a, clip_h, tooth_h, tooth_p) {
    difference() {
        clip_main_part(tbar_w, tbar_d, tbar_t, tbar_t0, clip_l, clip_w, clip_a, clip_h) ;
        translate([clip_l*0.75,0,clip_h])
            mirror([0,0,1])
                sawtooth_rack(clip_l*0.25, clip_w+2*delta, 1, tooth_h, tooth_p, tooth_p) ;

    }
}
////-test clip_main_toothed(tbar_w, tbar_d, tbar_t, tbar_t0, clip_l, clip_w, clip_a, clip_h, tooth_p)
clip_main_toothed(clip_tbar_w, clip_tbar_d, clip_tbar_t, clip_tbar_t0, clip_l, clip_tw, clip_ta, clip_th, retainer_tooth, retainer_pitch) ;


module clip_retainer(body_d, body_w, body_h, body_tw, body_th, body_ta, arm_l, arm_w, arm_t, lip, gap, catch) {
    difference() {
        union() {
            // Retaining clip slider body
            translate([-body_d+delta,-body_w/2,0])
                cube(size=[body_d, body_w, body_h], center=false) ;
            // Retaining clip gulley edge hook
            translate([-delta,body_w/2,0])
                rotate([0,0,-90])
                    wedge(body_w, lip, lip, 0) ;
            // Retaining clip positioning arm
            translate([0,-arm_w/2,body_h-arm_t])
                cube(size=[arm_l, arm_w, arm_t], center=false) ;
            // Retaining clip positioning catch
            translate([arm_l-catch,arm_w/2,body_h-arm_t+delta])
                rotate([-90,0,-90])
                    wedge(arm_w, catch, catch, 0) ;
        }
        translate([-body_d-delta,0,lip+gap])
            rotate([0,0,0])
                symmetric_trapezoid(
                    body_d+lip+delta*2, 
                    body_ta+clearance*2, 
                    body_tw+clearance*2, 
                    body_th+clearance*2
                    ) ;
    }
}

////-Test clip_retainer(body_d, body_w, body_h, body_tw, body_th, body_ta, arm_l, arm_w, arm_t, lip, gap, catch)
retainer_slider_h = clip_th+retainer_t+retainer_lip+retainer_gap+clearance*2 ;
module clip_retainer_part() {
    clip_retainer(
        retainer_d, retainer_w, retainer_slider_h,
        clip_tw, clip_th, clip_ta,
        gulley_edge_w+retainer_tooth, clip_tw+2, retainer_t, 
        retainer_lip, retainer_gap, retainer_catch
    ) ;    
}

// For assembly viewing:
// translate([clip_l+clip_tbar_d+5,0,-retainer_lip-retainer_gap]) clip_retainer_part() ;

// For printing with common baseline and no overhang
// translate([clip_l+clip_tbar_d+5,0,retainer_slider_h]) mirror([0,0,1]) clip_retainer_part() ;



module clip_retainer_toothed(body_d, body_w, body_h, body_tw, body_th, body_ta, arm_l, arm_w, arm_t, lip, gap, tooth_h, tooth_p) {
    rack_l = tooth_p*3 ;
    clip_retainer(body_d, body_w, body_h, body_tw, body_th, body_ta, arm_l, arm_w, arm_t, lip, gap, 0) ;
    translate([arm_l-rack_l,0,body_h-arm_t])
        mirror([0,0,1])
            sawtooth_rack(rack_l, arm_w, 1, tooth_h, tooth_h, tooth_p) ;



}
////-Test clip_retainer_toothed(body_d, body_w, body_h, body_tw, body_th, body_ta, arm_l, arm_w, arm_t, lip, gap, tooth_p)
module clip_retainer_toothed_part() {
    clip_retainer_toothed(
        retainer_d, retainer_w, retainer_slider_h,
        clip_tw, clip_th, clip_ta,
        gulley_edge_w, clip_tw+2, retainer_t, 
        retainer_lip, retainer_gap, retainer_tooth, retainer_pitch
    ) ;    
}

// For assembly viewing:
translate([clip_l+clip_tbar_d+5,0,-retainer_lip-retainer_gap]) clip_retainer_toothed_part() ;

// For printing with common baseline and no overhang
//translate([clip_l+clip_tbar_d+5,0,retainer_slider_h]) mirror([0,0,1]) clip_retainer_toothed_part() ;
