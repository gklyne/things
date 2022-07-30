
delta = 0.01 ;

t_hook_back   = 4 ;
t_hook_top    = 3 ;
t_hook_bottom = 3 ;
w_hook_bottom = 3 ;
t_hook_front  = 3 ;
l_hook_front  = 6 ;
l_hook_angled = 4 ;
r_inner       = 2 ;
r_outer       = r_inner+3 ;

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


module fillet_x_y(r, t) {
    // Fillet between X and Y axes
    difference() {
        translate([-delta, -delta, 0])
            cube(size=[r+delta,r+delta,t]) ;
        translate([r, r, -delta])
            cylinder(r=r, h=t+2*delta, $fn=32) ;
    }
}

module oval_x(l, w, t) {
    // l is distance between centres of the rounded ends
    // w is width of oval (also diameter of rounded ends)
    // t is thickness of oval
    r = w/2;
    translate([0,-w/2,0])
        cube(size=[l, w, t]) ;
    cylinder(d=w, h=t, $fn=32) ;
    translate([l,0,0])
        cylinder(d=w, h=t, $fn=32) ;
}

// Awning rail hook, with upper inner corner on the origin, and
// inner back of hook extending along the X axis
//
// l_inner      is length of inside of hook (height of awning rail)
// l_stub       is overall length of stub for clip at other end.
// w_inner      is width of inside of hook (thickness of awning rail)
// t_hook       is the thickness of the hook.
//
module awning_rail_hook(l_inner, w_inner, t_hook, l_stub) {
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
        translate([t_hook_top+l_hook_front, t_hook_back+w_hook_bottom, -delta])
            cube(size=[l_overall,w_overall,t_hook+2*delta]) ;
    }

    // Round off top of hook 
    translate([t_hook_top+l_hook_front,w_inner + t_hook_back + t_hook_front/2,0])
        cylinder(d=t_hook_front, h=t_hook, $fn=32) ;

    // Bottom retainer
    translate([l_inner + t_hook_top + t_hook_bottom/2, t_hook_back + w_hook_bottom,0])
        //cylinder(d=t_hook_bottom, h=t_hook, $fn=32) ;
        rotate([0,0,90+atan2(8,21)])
            oval_x(l_hook_angled, t_hook_bottom, t_hook) ;

    // Stub and fillet
    translate([l_inner,0,0])
        cube(size=[l_stub+t_hook_bottom+t_hook_top,t_hook_back,t_hook]) ;
    translate([l_inner+t_hook_bottom+t_hook_top,t_hook_back,0])
        fillet_x_y(r_inner, t_hook) ;
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
            rotate([0,0,90])
                oval_x(w_lower_hook, t_lower_hook, t_lower_hook) ;
        }
        translate([l_lower_hook,w_lower_hook,0]) {
            rotate([0,0,90+60])
                oval_x(w_lower_hook, t_lower_hook, t_lower_hook) ;
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

// Test

awning_rail_hook(36, 21, 6, 2) ;

l_inner = 36 ;
w_inner = 21 ;
l_stub  = 2 ;
l_taper = 8 ;
t_hook  = 6 ;
l_lower_hook = 6 ;
w_lower_hook = 8 ;
t_lower_hook = 3 ;

translate([l_inner+t_hook_top+t_hook_bottom+l_stub-delta,0,0])
    lower_hook(l_stub, t_hook, l_taper, l_lower_hook, w_lower_hook, t_lower_hook) ;
