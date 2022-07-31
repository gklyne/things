
delta = 0.01 ;

t_hook_back   = 4 ;
t_hook_top    = 3 ;
t_hook_bottom = 3 ;
t_hook_front  = 3 ;
l_hook_front  = 6 ;
//l_hook_angled = 12 ;
//a_hook_angled = atan2(10,20) ; // 26.5
r_inner       = 4 ;
r_outer       = r_inner+3 ;
r_fillet      = 4 ;

module rounded_rectangle(l, w, r, t) {
    translate([r,0,0])
        cube(size=[l-2*r,w,t]) ;
    translate([0,r,0])
        cube(size=[l,w-2*r,t]) ;
    translate([r,r,0])
        cylinder(h=t, r=r, $fn=32) ;
    translate([l-r,r,0])
        cylinder(h=t, r=r, $fn=32) ;
    translate([r,w-r,0])
        cylinder(h=t, r=r, $fn=32) ;
    translate([l-r,w-r,0])
        cylinder(h=t, r=r, $fn=32) ;
}


module fillet_x_y(r, t, overlap) {
    // Fillet between X and Y axes
    difference() {
        translate([-overlap, -overlap, 0])
            cube(size=[r+overlap,r+overlap,t]) ;
        translate([r, r, -delta])
            cylinder(r=r, h=t+2*delta, $fn=32) ;
    }
}

module oval_x(l, w, t) {
    // l is distance between centres of the rounded ends
    // w is width of oval (also diameter of rounded ends)
    // t is thickness of oval
    translate([0,-w/2,0])
        cube(size=[l, w, t]) ;
    cylinder(d=w, h=t, $fn=32) ;
    translate([l,0,0])
        cylinder(d=w, h=t, $fn=32) ;
}


module ballend_x(l, w) {
    // Like an oval, but with ball ends.
    od = w/cos(22.5) ;
    translate([0,-w/2,0])
        cube(size=[l, w, w]) ;
    translate([0,0,w/2])
        sphere(d=od, $fn=8) ;
    translate([l,0,w/2])
        sphere(d=od, $fn=8) ;
}


module sossij_x(l, w) {
    // Like an oval, but with "rounded" cross-section.
    // (actually, octagonal, to allow the overhang to print)
    od = w/cos(22.5) ;
    intersection() {
        ballend_x(l, w) ;
        translate([-w,0,w/2])
            rotate([0,90,0])
                rotate([0,0,22.5])
                    cylinder(d=od, h=l+w*2, $fn=8) ;
    }
}


// Awning rail hook, with upper inner corner on the origin, and
// inner back of hook extending along the X axis
//
// l_inner      is length of inside of hook (height of awning rail)
// w_inner      is width of inside of hook (thickness of awning rail)
// w_bottom     ius the width of the bottom hook (not with the angled section)
// l_angled     length of angled retaining arm at bottom
// a_angled     angle (deg from horizontal) of retaining arm at bottom
// t_hook       is the thickness of the hook.
// l_stub       is overall length of stub for clip at other end.
//
module awning_rail_hook(l_inner, w_inner, w_bottom, l_angled, a_angled, t_hook, l_stub) {
    l_overall = l_inner + t_hook_top + t_hook_bottom + l_stub ;
    w_overall = w_inner + t_hook_back + t_hook_front ; 
    difference() {
        rounded_rectangle(
            l_inner+t_hook_top+t_hook_bottom, 
            w_inner+t_hook_back+t_hook_front, 
            r_outer, t_hook) ;
        translate([t_hook_top,t_hook_back,-delta])
            rounded_rectangle(
                l_inner, 
                w_inner, 
                r_inner, t_hook+2*delta) ;
        translate([t_hook_top+l_hook_front, t_hook_back+w_bottom, -delta])
            cube(size=[l_overall,w_overall,t_hook+2*delta]) ;
    }

    // Round off top of hook 
    translate([t_hook_top+l_hook_front,w_inner + t_hook_back + t_hook_front/2,0])
        cylinder(d=t_hook_front, h=t_hook, $fn=32) ;

    // Bottom retainer
    translate([l_inner + t_hook_top + t_hook_bottom/2, t_hook_back + w_bottom,0])
        //cylinder(d=t_hook_bottom, h=t_hook, $fn=32) ;
        rotate([0,0,90+a_angled])
            oval_x(l_angled, t_hook_bottom, t_hook) ;

    // Stub and fillet
    translate([l_inner,0,0])
        cube(size=[l_stub+t_hook_bottom+t_hook_top,t_hook_back,t_hook]) ;
    translate([l_inner+t_hook_bottom+t_hook_top,t_hook_back,0])
        fillet_x_y(r_fillet, t_hook, t_hook_bottom) ;
}


module tapered_cuboid(l,w1,h1,w2,h2) {
    y21 = (w1-w2)/2 ;
    y22 = (w1+w2)/2 ;
    // NOTE: a bug in OpenSCAD can result in rendering errors (but not preview errors)
    // if the faces are listed with differing "winding order".  This code fixes the 
    // problem by listing vertices for each face in clockwise sequence when looking 
    // towards the centre of the polyhedron.
    polyhedron(
        points=[ [0,0,0],   [0,w1,0],  [0,w1,h1],  [0,0,h1],     // 0
                 [l,0,0],   [l,w2,0],  [l,w2,h2],  [l,0,h2]      // 4
                 // [l,y21,0], [l,y22,0], [l,y22,h2], [l,y21,h2]    // 4
               ],
        faces=[ [0,1,2,3], [0,4,5,1], [0,3,7,4], [1,5,6,2], [2,6,7,3], [4,7,6,5] ]
    ) ;


}

module simple_hook(l_lower_hook, w_lower_hook, t_lower_hook) {
    translate([0,t_lower_hook/2,0]) {
        oval_x(l_lower_hook, t_lower_hook, t_lower_hook) ;
        translate([l_lower_hook,0,0]) {
            rotate([0,0,90]) {
                sossij_x(w_lower_hook, t_lower_hook) ;
                translate([w_lower_hook,0,0]) {
                    rotate([0,0,75]) {
                        l_hook_return = w_lower_hook*0.75 ;
                        sossij_x(l_hook_return, t_lower_hook) ;
                        l_lower_retainer = w_lower_hook - t_lower_hook ;
                        translate([l_hook_return,0,0]) {
                            rotate([0,0,75])
                                sossij_x(l_lower_retainer, t_lower_hook) ;
                        }
                    }
                }
            }
        }
    }
}

module lower_hook(l_stub, t_hook, l_taper, l_lower_hook, w_lower_hook, t_lower_hook) {
    cube(size=[l_stub+delta,t_hook_back,t_hook]) ;
    translate([l_stub,0,0])
        tapered_cuboid(l_taper+delta, t_hook_back, t_hook, t_lower_hook, t_lower_hook) ;
    translate([l_stub+l_taper,0,0])
        simple_hook(l_lower_hook, w_lower_hook, t_lower_hook) ;
}

// Print

// Lower hook parameters
l_taper = 8 ;
l_lower_hook = 6 ;
w_lower_hook = 8 ;
t_lower_hook = 3 ;

// Small awning rail hook
l_inner_small  = 37.2 ;
w_inner_small  = 21 ;
w_bottom_small = 5 ;
l_angled_small = 12 ;
a_angled_small = 27 ;
t_hook         = 6 ;
l_stub         = 2 ;
translate([0,-30,0]) {
    awning_rail_hook(
        l_inner_small, w_inner_small, w_bottom_small, 
        l_angled_small, a_angled_small, 
        t_hook, l_stub ) ;
    translate([l_inner_small+t_hook_top+t_hook_bottom+l_stub-delta,0,0])
        lower_hook(l_stub, t_hook, l_taper, l_lower_hook, w_lower_hook, t_lower_hook) ;
}

// Large awning rail hook
l_inner_large  = 53 ;
w_inner_large  = 24 ;
w_bottom_large = 9 ;
l_angled_large = 12 ;
a_angled_large = 38 ;
//t_hook         = 6 ;
//l_stub         = 2 ;
translate([0,5,0]) {
    awning_rail_hook(
        l_inner_large, w_inner_large, w_bottom_large, 
        l_angled_large, a_angled_large, 
        t_hook, l_stub ) ;
    translate([l_inner_large+t_hook_top+t_hook_bottom+l_stub-delta,0,0])
        lower_hook(l_stub, t_hook, l_taper, l_lower_hook, w_lower_hook, t_lower_hook) ;
}
