////////////////////////////////////////////////////////////////////////////////
// Common components
////////////////////////////////////////////////////////////////////////////////

delta = 0.01 ;
clearance = 0.1 ;

// Common dimensions

m_clearance = 0.25 ;        // Clearance for close-clearance holes
m2_5    = 2.5+m_clearance ; // Close clearance hole for M2.5 screw
m3      = 3+m_clearance ;   // Close clearance hole for M3 screw
m4      = 4+m_clearance ;   // Close clearance hole for M4 screw
m5      = 5+m_clearance ;   // Close clearance hole for M5 screw
m6      = 6+m_clearance ;   // Close clearance hole for M6 screw/sleeve
m8      = 8+m_clearance ;   // Close clearance hole for M8 screw/sleeve

m2_5_nut_af = 5.0 ;         // M2.5 nut a/f size
m2_5_nut_t  = 2.0 ;         // M2.5 nut thickness (for recess)
m2_5_csink  = m2_5*2 ;      // M2.5 countersink diameter

m3_nut_af    = 5.5 ;        // M3 nut a/f size
m3_nut_t     = 2.2 ;        // M3 nut thickness (for recess)
m3_hinge_dia = 8.0 ;        // M3 hinge knuckle diameter
m3_csink     = m3*2 ;       // M3 countersink diameter

m4_nut_af    = 7 ;          // M4 nut a/f size
m4_nut_t     = 3.1 ;        // M4 nut thickness (for recess)
m4_slimnut_t = 2.5 ;        // M4 slim nut thickness (for recess)
m4_nylock_t  = 4.3 ;        // M4 nylock nut thickness (for recess)
m4_csink     = m4*2 ;       // M4 countersink diameter
m4_washer_d  = 8.9 ;        // M4 washer diameter
m4_washer_t  = 0.9 ;        // M4 washer thickness

m8_nut_af    = 13 ;         // M8 nut a/f size
m8_nut_t     = 6.5 ;        // M8 nut thickness (for recess)
m8_slimnut_t = 4 ;          // M8 slim nut thickness (for recess)

// Plates

module triangle_plate(x1,y1,x2,y2,x3,y3,h) {
    // Trangular plate on X-Y plane
    //
    // x1 = X position of first apex
    // y1 = Y position of first apex
    // x2 = X position of second apex
    // y2 = Y position of second apex
    // x3 = X position of third apex
    // y3 = Y position of third apex
    // h  = height (thickness) of plate
    linear_extrude(height=h, center=false) {
        polygon(
            points=[
                [x1,y1],
                [x2,y2],
                [x3,y3],
                [x1,y1],
                ]
            ) ;
    }
}
////-triangle_plate(x1,y1,x2,y2,x3,y3,h) instance
// triangle_plate(-10,-10,-10,+10,10,5,5) ;

module rectangle_plate(x1,y1,x2,y2,h, scale=1) {
    // Rectangular plate on X-Y plane
    //
    // x1 = X position of first apex
    // y1 = Y position of first apex
    // x2 = X position of opposite apex
    // y2 = Y position of opposite apex
    // h  = height (thickness) of plate
    // scale = reduces X-Y coordinates towards top of plate (see linear_extrude)
    //
    linear_extrude(height=h, center=false, scale=scale) {
        polygon(
            points=[
                [x1,y1],
                [x2,y1],
                [x2,y2],
                [x1,y2],
                [x1,y1],
                ]
            ) ;
    }
}
////-rectangle_plate(x1,y1,x2,y2,h, scale=1) instance
// rectangle_plate(-10,-10,10,15,5) ;
// rectangle_plate(10,15,20,30,5, scale=0.5) ;

module lozenge(l,bevel_l,w,h) {
    // Lozenge object along Z axis: one point on origin, other on X-axis
    //
    // l       = overall length (between points)
    // bevel_l = length of sloping shoulder
    // w       = width of lozenge
    // h       = height of lozenge
    //
    linear_extrude(height=h, center=false) {
        polygon(
            points=[
                [0,        0],  
                [bevel_l,  w/2],
                [l-bevel_l,w/2],
                [l,        0],
                [l-bevel_l,-w/2],
                [bevel_l,  -w/2],
                ]
            ) ;
    }
}

module oval(x, d, h) {
    // Oval shape aligned on the X axis, with one end centred on the origin
    //
    // x  = X position of second centre of curvature
    // d  = width of oval, also diameter of curved ends
    // h  = height (thickness) of oval
    //
    cylinder(d=d, h=h, $fn=16) ;
    translate([x,0,0])
        cylinder(d=d, h=h, $fn=16) ;
    translate([x/2,0,h/2])
        cube(size=[x, d, h], center=true) ;
}

module oval_xy(x1, y1, x2, y2, d, h) {
    // Oval shape on the X-Y plane, with ends at the indicated positions
    //
    // x1 = X position of first centre of curvature
    // y1 = Y position of first centre of curvature
    // x2 = X position of second centre of curvature
    // y2 = Y position of second centre of curvature
    // d  = width of oval, also diameter of curved ends
    // h  = height (thickness) of oval
    //
    l = sqrt((x2-x1)^2+(y2-y1)^2) ;     // Length of oval (between radius centres)
    a = atan2(y2-y1,x2-x1) ;            // Angle of oval from X-axis
    translate([x1,y1,0]) {
        cylinder(d=d, h=h, $fn=16) ;
        rotate([0,0,a])
            translate([0,-d/2,0])
                cube(size=[l, d, h], center=false) ;
    }
    translate([x2,y2,0])
        cylinder(d=d, h=h, $fn=16) ;
}
////-oval_xy(x1, y1, x2, y2, d, h) instance
// oval_xy(-20,30,-60,-60,10,5) ;


module hub(d, h) {
    // Hub: cylinder with hole for fixing, on X-Y plane, centred on the origin
    //
    // d  = diameter of fixing hole
    // h  = height (thickness) of hub
    //
    difference() {
        cylinder(d=d*1.6, h=h, $fn=16) ;
        shaft_hole(d, h) ;
    }
}

module brace_xy(x1, y1, x2, y2, w, d1, d2, h) {
    // Brace with rounded ends with fixing holes
    //
    // x1 = X position of first fixing hole
    // y1 = Y position of first fixing hole
    // x2 = X position of second fixing hole
    // y2 = Y position of second fixing hole
    // w  = width of brace
    // d1 = diameter of fixing hubs
    // d2 = diameter of fixing holes
    // h  = height (thickness) of brace
    //
    l = sqrt((x2-x1)^2+(y2-y1)^2) ;     // Length of brace (between radius centres)
    a = atan2(y2-y1,x2-x1) ;            // Angle of brace from X-axis
    difference() {
        union() {
            translate([x1,y1,0]) {
                cylinder(d=d1, h=h, $fn=16) ;
                rotate([0,0,a])
                    translate([0,-w/2,0])
                        cube(size=[l, w, h], center=false) ;
            }
            translate([x2,y2,0])
                cylinder(d=d1, h=h, $fn=16) ;
        }
        translate([x1,y1,0]) shaft_hole(d2, h) ;
        translate([x2,y2,0]) shaft_hole(d2, h) ;
    }
}
////-brace_xy(x1, y1, x2, y2, w, d1, d2, h) instance
// brace_xy(-20,30,-60,-60,8,12,8,5) ;


module shaft_hole(d, l) {
    // Cutout for shaft hole diameter d and length l
    // Shaft axis on Z axis.
    //
    translate([0,0,-delta]) {
        cylinder(d=d, h=l+delta*2, $fn=16) ;
    };
}

module shaft_slot(x1, x2, y, d, h) {
    translate([x1,y,-delta])
        oval(x2-x1, d, h+2*delta) ;    
}

module rounded_triangle_plate(x1,y1,x2,y2,x3,y3,r,h) {
    // Trangular plate on X-Y plane with rounded corners
    //
    // x1 = X position of first corner (centre of radius)
    // y1 = Y position of first corner (centre of radius)
    // x2 = X position of second corner (centre of radius)
    // y2 = Y position of second corner (centre of radius)
    // x3 = X position of third corner (centre of radius)
    // y3 = Y position of third corner (centre of radius)
    // r  = radius of rounded corners
    // h  = height (thickness) of plate
    d = r*2 ;
    triangle_plate(x1,y1,x2,y2,x3,y3,h) ;
    oval_xy(x1,y1,x2,y2,d,h) ;
    oval_xy(x2,y2,x3,y3,d,h) ;
    oval_xy(x3,y3,x1,y1,d,h) ;
}
////-rounded_triangle_plate(x1,y1,x2,y2,x3,y3,r,h) instance
// rounded_triangle_plate(-20,-20, -10,+10, 10,5, 3,5) ;


module rounded_rectangle_plate(x1,y1,x2,y2,r,h) {
    // Rectangular plate on X-Y plane with rounded corners
    //
    // x1 = X position of first corner (centre of radius)
    // y1 = Y position of first corner (centre of radius)
    // x2 = X position of opposite corner (centre of radius)
    // y2 = Y position of opposite corner (centre of radius)
    // r  = radius of rounded corners
    // h  = height (thickness) of plate
    d = r*2 ;
    rectangle_plate(x1,y1,x2,y2,h) ;
    oval_xy(x1,y1,x1,y2,d,h) ;
    oval_xy(x1,y2,x2,y2,d,h) ;
    oval_xy(x2,y2,x2,y1,d,h) ;
    oval_xy(x2,y1,x1,y1,d,h) ;
}
////-rounded_rectangle_plate(x1,y1,x2,y2,r,h) instance
// rounded_rectangle_plate(-10,-10, 10,15, 3,5) ;

module torus(tr, rr) {
    // Torus centred on origin.
    //
    // tr       torus radius (centre of ring to centre of rim)
    // rr       rim radius
    //
    rotate_extrude($fn=64) {
        translate([tr,0,0])
            circle(r=rr, $fn=32) ;
    }
}
////-torus(tr, rr) instance
// torus(20, 3);

// Triangular prism on X-Y plane, centred and aligned on X-axis, one end at origin
//
// w  = width of base of prism
// h  = height of apex
// l  = length of prism
//
module triangular_prism(w,h,l) {
    rotate([0,90,0])
        linear_extrude(height=l)
            polygon(
                points=[
                    [0,  -w/2], 
                    [0,  +w/2],
                    [-h, 0],
                    ],
                paths=[[0,1,2,0]]
                ) ;
}

// Trapezoidal prism on X-Y plane, centred and aligned on X-axis, one end at origin
//
// w1 = width of base of prism
// w2 = width at top of prism
// h  = height of top of prism
// l  = length of prism
//
module trapezoidal_prism(w1,w2,h,l) {
    rotate([0,90,0])
        linear_extrude(height=l)
            polygon(
                points=[
                    [0,  -w1/2], 
                    [0,  +w1/2],
                    [-h, -w2/2],
                    [-h, +w2/2],
                    ],
                paths=[[0,2,3,1,0]]
                ) ;
}

// Platform to fit inside vertically-printed cylinder, with angled infill below.
// Top of platform lies in X-Y plane, centred on origin.
//
// r  = radius of platform
// h  = height of platform infill
//
module circular_platform(r,h) {
    translate([0,0,-h]) {
        difference() {
            cylinder(r=r+delta, h=h) ;
            translate([0, 0,-delta])
                cylinder(r1=r+delta, r2=0, h=h) ;  
        }
    }
}
////-circular_platform(r,h) instance
// Instance of circular_platform (With cutaway to reveal angle of support.)
// difference() { circular_platform(10,8) ; translate([0,0,-10]) cube(size=[20,20,20]) ; }

module nut(af, t, sd) {
    // Nut outline shape
    //
    // af = size of nut across faces (across flats, = spanner size)
    // t  = thickness of nut
    // sd = shaft diameter through nut
    //
    od = af * 2 / sqrt(3) ; // Diameter
    difference() {
        cylinder(d=od, h=t, $fn=6) ;
        translate([0,0,-delta])
            cylinder(d=sd, h=t+delta*2, $fn=12) ;
    }
}


// Hex nut recess on centre of X-Y plane, extending +Z from origin.
//
// af = nut dimension AF (across flats, = spanner size)
// t  = thickness of nut
//
module nut_recess_Z(af, t) {
    od = af * 2 / sqrt(3) ; // Diameter
    cylinder(d=od, h=t+delta*2, $fn=6) ;
}
////-nut_recess_Z(af, t)
// nut_recess_Z(m4_nut_af, m4_nut_t) ;


// Hex screw recess on centre of X-Y plane, extending +Z from origin.
//
// sd       = diameter of screw
// sl       = length of screw (including head)
// nut_af   = nut dimension AF (across flats, = spanner size)
// nut_t    = thickness of nut
//
module hex_screw_recess_Z(sd, sl, nut_af, nut_t) {
    nut_recess_Z(nut_af, nut_t) ;
    cylinder(d=sd, h=sl+delta, $fn=16) ;
}
////-hex_screw_recess_Z(sd, sl, af, t)
// hex_screw_recess_Z(m4, 10, m4_nut_af, m4_nut_t) ;


// Hex nut recess on centre of Y-Z plane, extending +X from origin.
//
// Doesn't require code for printing support; orient sloping sides top and bottom.
//
// af = nut dimension AF (across flats, = spanner size)
// t  = thickness of nut
//
module nut_recess_X(af, t) {
    rotate([0,90,0])
        nut_recess_Z(af, t) ;
}
////-nut_recess_X(af, t)
// nut_recess_X(m4_nut_af, m4_nut_t) ;

// Hex screw recess on centre of Y-Z plane, extending +X from origin.
//
// Doesn't require code for printing support; orient sloping sides top and bottom.
//
// sd       = diameter of screw
// sl       = length of screw (including head)
// nut_af   = nut dimension AF (across flats, = spanner size)
// nut_t    = thickness of nut
//
module hex_screw_recess_X(sd, sl, nut_af, nut_t) {
    rotate([0,90,0])
        hex_screw_recess_Z(sd, sl, nut_af, nut_t) ;
}
////-hex_screw_recess_X(af, t)
// hex_screw_recess_X(m4_nut_af, m4_nut_t) ;



// Return height of nut recess cone given across-flats size of nut
// This value should allow for an achievable slope without support
//
function nut_recess_height(af) = af*0.30 ;

// Hex nut recess on centre of X-Y plane
//
// af = nut dimension AF (across flats, = spanner size)
// t  = thickness of nut
//
module nut_recess(af, t)  {
    od = af * 2 / sqrt(3) ; // Diameter
    translate([0,0,-delta]) {
        cylinder(d=od, h=t+delta*2, $fn=6) ;
    // Cone above to allow printing without support:
    // Leaves flat shoulders at corners to support nut: 
    // assume that these are short enough for the printing to bridge.
    // Similarly, tip of pyramid is truncated.
    translate([0,0,t])
        cylinder(d1=af-0.25, d2=2, h=nut_recess_height(af), $fn=12) ;
    }
}

module extended_nut_recess(af, t, l) {
    // Extended nut cutout on X-Y plane, with nut centred on the origin, extends along X-axis
    //
    // af = size of nut across faces (across flats, = spanner size)
    // t  = thickness of nut
    // l  = length of cutout
    //
    od = af * 2 / sqrt(3) ; // Diameter (across corners)
    sl = af-0.6 ;           // Width of nut support ledge
    co = af*0.26 ;          // Offset of cutout (leaving ridge to retain nut) 
    translate([0,0,-delta]) {
        cylinder(d=od, h=t+delta*2, $fn=6) ;
        translate([0,-af/2,0])
            cube(size=[l,af,t+delta*2]) ;
    }
    // Cone and "roof" above for printing overhang
    translate([0,0,t]) {
        cylinder(d1=sl, d2=2, h=nut_recess_height(af), $fn=12) ;
        translate([co,0,0])
            trapezoidal_prism(w1=sl, w2=2, h=nut_recess_height(af), l=l-co) ;
    }
}
////-extended_nut_recess(af, t, l) instance
// extended_nut_recess(m4_nut_af, m4_nut_t, 20) ;


module extended_nut_recess_with_ejection_hole(af, t, l) {
    // Extended nut cutout on X-Y plane, with nut centred on the origin, extends along X-axis
    // and ejection hole extending on -X axis
    //
    // af = size of nut across faces (across flats, = spanner size)
    // t  = thickness of nut
    // l  = length of cutout (and ejection hole)
    //
    extended_nut_recess(af, t, l) ;
    // Nut ejection hole
    translate([0,0,t/2])
        rotate([0,90,0])
            cylinder(d=t,h=l*2, $fn=6, center=true) ;
}
////-extended_nut_recess_with_ejection_hole(af, t, l) instance
// extended_nut_recess_with_ejection_hole(m4_nut_af, m4_nut_t, 20) ;


// Return height of nut recess given across-flats size of nut
//
function nylock_recess_height(af) = af*0.38 ;

module extended_nylock_recess(af, t, l) {
    // Extended nylock cutout on X-Y plane, with nut centred on the origin, extends along X-axis
    //
    // To allow insertion of the nut either way, the conical ends extend both up and down
    //
    // af = size of nut across faces (across flats, = spanner size)
    // t  = thickness of nut
    // l  = length of cutout
    //
    od = af * 2 / sqrt(3) ; // Diameter (across corners)
    sl = af - 0.6 ;         // Width of nut support ledge
    co = af*0.26 ;          // Offset of cutout (leaving ridge to retain nut) 
    translate([0,0,-delta]) {
        cylinder(d=od, h=t+delta*2, $fn=6) ;
        translate([0,-af/2,0])
            cube(size=[l,af,t+delta*2]) ;
    }
    // Cone above for nylock dome and printing overhang
    translate([0,0,t]) {
        cylinder(d1=sl, d2=2, h=nylock_recess_height(af), $fn=12) ;
        translate([co,0,0])
            trapezoidal_prism(w1=sl, w2=2, h=nylock_recess_height(af), l=l-co) ;
    }
    // Cone below for nylock dome
    translate([0,0,-nylock_recess_height(af)]) {
        cylinder(d1=2, d2=sl, h=nylock_recess_height(af), $fn=12) ;
        translate([co,0,0])
            trapezoidal_prism(w1=2, w2=sl, h=nylock_recess_height(af), l=l-co) ;
    }
}
////-extended_nylock_recess(af, t, l) instance
//extended_nylock_recess(m4_nut_af, m4_nylock_t, 20) ;

module extended_nylock_recess_with_ejection_hole(af, t, l) {
    // Extended nut cutout on X-Y plane, with nut centred on the origin, extends along X-axis
    // and ejection hole extending on -X axis
    //
    // af = size of nut across faces (across flats, = spanner size)
    // t  = thickness of nut
    // l  = length of cutout (and ejection hole)
    //
    extended_nylock_recess(af, t, l) ;
    // Nut ejection hole
    translate([0,0,t/2])
        rotate([0,90,0])
            cylinder(d=t,h=l*2, $fn=6, center=true) ;
}
////-extended_nylock_recess_with_ejection_hole(af, t, l) instance
// extended_nylock_recess_with_ejection_hole(m4_nut_af, m4_nylock_t, 20) ;

////-Test nylock cutout in small cylinder
////-test-extended_nylock_recess_with_ejection_hole
// difference() {
//     translate([0,0,-5])
//         cylinder(d=15, h=18, $fn=16) ;
//     translate([0,0,-6])
//         cylinder(d=4,  h=20, $fn=16) ;
//     // Using dimensions for M4 nylock nut
//     extended_nylock_recess_with_ejection_hole(m4_nut_af, m4_nylock_t, 20) ;
// }


// Cutout for vertical screw hole with downward-facing countersink at top, 
// centred on origin.
//
// The centre of the countersink top face lies on the origin.
// The countersink and screw shaft hole lie on the -ve Z axis
// A recess hole lies along the +ve Z axis 
//
// od = overall diameter (for screw head)
// oh = overall height (screw + head + recess)
// sd = screw diameter
// sh = screw height (to top of countersink)
//
module countersinkZ(od, oh, sd, sh)
{
    // echo("countersinkZ od: ", od) ;
    // echo("countersinkZ oh: ", oh) ;
    // echo("countersinkZ sd: ", sd) ;
    // echo("countersinkZ sh: ", sh) ;
    union()
    {
        intersection()
        {
            // Head recess
            translate([0,0,-sh]) cylinder(d=od, h=oh, $fn=12);
            // Countersink cone
            translate([0,0,-od/2]) cylinder(r1=0, r2=oh+od/2, h=oh+od/2, $fn=12);
        }
    // shaft
    translate([0,0,-sh]) cylinder(d=sd, h=oh, $fn=12);
    }
}

// Countersink with screw directed along negative X-axis
module countersinkX(od, oh, sd, sh)
{
    rotate([0,90,0]) countersinkZ(od, oh, sd, sh);
}

// Countersink with screw directed along negative Y-axis
module countersinkY(od, oh, sd, sh)
{
    rotate([90,0,0]) countersinkZ(od, oh, sd, sh);
}


////////////////////////////////////////////////////////////////////////////////
// Hinge parts
////////////////////////////////////////////////////////////////////////////////

module hinge_outer(l, ow, tw, pt, kd, sd, nut_af, nut_t) {
    // Outer hinge part, with hinge line on +Z axis.
    //
    // Has shaft attachment at each end, countersunk on bottom face and with
    // nut recess on upper.
    //
    // Print with supports between shaft attachments.
    //
    // l        = length of plate (end to hinge pivot line)
    // ow       = overall width of attachment plate
    // tw       = width for hinge tongue between shaft attachment knuckles
    // pt       = thickness of hinge plate
    // kd       = diameter of hinge knuckle
    // sd       = diameter of pivot shaft
    // nut_af   = nut recess dimension across faces
    // nut_t    = nut recess depth (thickness of nut)
    //
    kh = (ow-tw)/2 ;    // Height of hinge knuckle (top and bottom)
    tl = kd*0.6 ;       // Tongue length (to pivot line
    kc = clearance ;    // Knuckle end-clearance gap
    difference() {
        union() {
            translate([0,-pt/2,0]) cube(size=[l, pt, ow]) ;     // Main plate
            cylinder(d=kd, h=ow, $fn=12) ;                      // Knuckle
        }
        translate([0,0,kh-kc])
            cylinder(r=tl, h=tw+kc*2, $fn=12) ;                 // Space for hinge tongue
        //translate([0,0,-delta])
        //    cylinder(d=sd, h=ow+2*delta, $fn=12) ;            // Shaft hole
        translate([0,0,-delta])
            rotate([180,0,0])                                   // Shaft hole with countersink
                countersinkZ((sd-m_clearance)*2, ow+2*delta, sd, ow+2*delta) ;  
        translate([0,0,(ow-nut_t)])
            nut_recess(nut_af, nut_t+delta) ;                   // Nut recess at top
    }
}


module hinge_inner(l, ow, tw, pt, kd, sd) {
    // Inner hinge part, with hinge line on +Z axis.
    //
    // Has shaft attachment at each end, countersunk on bottom face and with
    // nut recess on upper.
    //
    // Print with supports under hinge tongue.
    //
    // l        = length of plate (end to hinge pivot line)
    // ow       = overall width of attachment plate
    // tw       = width for hinge tongue between shaft attachment knuckles
    // pt       = thickness of hinge plate
    // kd       = diameter of hinge knuckle
    // sd       = diameter of pivot shaft
    //
    kh = (ow-tw)/2 ;    // Height of hinge knuckle (top and bottom)
    tl = kd*0.6 ;       // Tongue length (to pivot line
    kc = clearance ;    // Knuckle end-clearance gap
    difference() {
        union() {
            difference() {
                translate([0,-pt/2,0]) cube(size=[l, pt, ow]) ; // Main plate
                translate([0,0,-delta])
                    cylinder(r=tl, h=kh+kc+delta, $fn=12) ; // Knuckle cut-out bottom
                translate([0,0,ow-kh-kc+delta])
                    cylinder(r=tl, h=kh+kc+delta, $fn=12) ; // Knuckle cut-out top
                }
        translate([0,0,kh+kc])
            cylinder(d=kd, h=tw-kc*2, $fn=12) ;      // Hinge knuckle
        }
    translate([0,0,-delta])
        cylinder(d=sd, h=ow+2*delta, $fn=12) ;              // Shaft hole
    }
}


// //-hinge_outer(l, ow, tw, pt, kd, sd, nut_af, nut_t)
// translate([10,0,0]) hinge_outer(15, 20, 10, 4, 10, m4, m4_nut_af, m4_nut_t) ;
// //-hinge_inner(l, ow, tw, pt, kd, sd)
// translate([-10,0,0]) rotate([0,0,180]) hinge_inner(15, 20, 10, 4, 10, m4) ;

////////////////////////////////////////////////////////////////////////////////
// Basic wheel shapes
////////////////////////////////////////////////////////////////////////////////

module wheel(r,t) {
    // Wheel blank lying on X-Y plane, centred on the origin
    //
    // r  = radius
    // t  = thickness
    cylinder(r=r, h=t, center=false, $fn=48) ;
}

module pulley(d,t) {
    // Pulley outside diameter d, thickness t, on X-Y plane and centred on Z axis
    cylinder(d1=d, d2=d-t*0.85, h=t/2+delta) ;
    translate([0,0,t/2])
        cylinder(d1=d-t*0.85, d2=d, h=t/2+delta) ;    
}

module pulley_round_belt(pd, pw, bd) {
    // Pulley with channel for round belt, lying on X-Y plane, centred at origin.
    //
    // pd = diameter of pulley
    // pw = width of pulley
    // bd = diameter of drive belt
    //
    a  = 75 ;               // Overhang angle at edge of pulley
    td = pd + bd*cos(a) ;   // Torus diameter (to centre of rim)
    difference() {
        cylinder(d=pd, h=pw, center=false, $fn=48) ;
        translate([0,0,pw/2])
            torus(td/2, bd/2) ;
    }
}
////-pulley_round_belt(pd, pw, bd) instance
// pulley_round_belt(30, 5, 4) ;


module ring(r1, r2, t) {
    // Circular ring lying on X-Y plane, centred on the origin
    //
    // r1 = inner radius
    // r2 = outer radius
    // t  = thickness
    difference() {
        cylinder(r=r2, h=t, center=false, $fn=48) ;
        translate([0,0,-delta])
            cylinder(r=r1, h=t+2*delta, center=false, $fn=48) ;
    }
}
////-ring(r1, r2, t) instance
// ring(20, 40, 5) ;


module segment_cutout(a1, a2, sr, t) {
    // Cutout (use with `difference()`) to remove all but a segment of a shape.
    //
    // NOTE: only works for angles up to 180 degrees.
    //
    // a1 = first radial edge angle for the resulting segment
    // a2 = second radial edge angle for the resulting segment (a2>a1)
    // sr = maximum segment radius
    // t  = thickness of segment
    //
    rotate([0,0,a1])
        translate([-(sr+delta), -(sr+delta), -delta])
            cube(size=[2*(sr+delta), sr+delta, t+2*delta], center=false) ;
    rotate([0,0,a2])
        translate([-(sr+delta), 0, -delta])
            cube(size=[2*(sr+delta), sr+delta, t+2*delta], center=false) ;
}


module segment(a, sr, t) {
    // Circle segment in X-Y plane with centre on origin, and one radial edge on
    // the positive X-axis.  The second radial edge is `a` degrees anticlockwise 
    // from the positive X-axis.
    //
    // NOTE: only works for angles up to 180 degrees.
    //
    // a  = angle of segment
    // sr = radius of segment
    // t  = thickness of segment
    //
    difference() {
        cylinder(r=sr, h=t, center=false, $fn=48) ;
        segment_cutout(0, a, sr, t) ;
    }
}
////-segment(a, sr, t) instance
// segment(60, 20, 5) ;


module ring_segment(a1, a2, r1, r2, t) {
    // Circular ring segment lying on X-Y plane, centred on the origin, with radial 
    // edges at `a1` and `a2` degrees anticlockwise from the positive X-axis.
    //
    // NOTE: only works for angles up to 180 degrees.
    //
    // a1 = first radial edge angle
    // a2 = second radial edge angle (a2>a1)
    // r1 = inner radius
    // r2 = outer radius
    // t  = thickness
    difference() {
        ring(r1, r2, t) ;
        translate([0,0,-delta])
            segment_cutout(a1, a2, r2+delta, t+delta*2) ;
    }
}
////-ring_segment(a1, a2, r1, r2, t) instance
// ring_segment(60, 120, 30, 40, 5) ;

module ring_segment_rounded(a1, a2, r1, r2, t) {
    // Like ring_segment, but with semicircular rounded ends added to the ring
    //
    // NOTE: only works for angles up to 180 degrees.
    //
    // a1 = first radial edge angle
    // a2 = second radial edge angle (a2>a1)
    // r1 = inner radius
    // r2 = outer radius
    // t  = thickness
    ring_segment(a1, a2, r1, r2, t) ;
    for ( a = [a1, a2] ) {
        cx = (r1+r2)*cos(a)*0.5 ;
        cy = (r1+r2)*sin(a)*0.5 ;
        translate([cx,cy,0])
            cylinder(d=r2-r1, h=t, $fn=24) ;
    }
}
////-ring_segment_rounded(a1, a2, r1, r2, t) instance
//ring_segment_rounded(60, 120, 30, 40, 5) ;

module ring_segment_slotted(a1, a2, r1, r2, t, sa1, sa2, sr1, sr2) {
    // Slotted ring segment.
    // Like ring_segment_rounded, with with circular slot around same centre
    //
    // a1   = first radial edge angle (to centre of rounded end)
    // a2   = second radial edge angle (a2>a1)
    // r1   = inner radius
    // r2   = outer radius
    // t    = thickness
    // sa1  = first radial angle for slot (to centre of rounded end of slot)
    // sa2  = second radial angle for slot
    // sr1  = inner radius of slot
    // sr2  = outer radius of slot
    //
    difference() {
        ring_segment_rounded(a1, a2, r1, r2, t) ;
        translate([0,0,-delta]) 
            ring_segment_rounded(sa1, sa2, sr1, sr2, t+2*delta) ;
    }
}

////-ring_segment_rounded(a1, a2, r1, r2, t) instance
// ring_segment_slotted(60, 120, 30, 40, 5, 65, 115, 33, 37) ;

module segment_rounded(a, sr, t, fr) {
    // Circle segment (see `segment`) but with corners rounded with 
    // fillet radius fr.
    //
    // NOTE: only works for angles up to 180 degrees.
    //
    // NOTE: calculation for p2 and p3 are approximate, based on an assumption
    // that fr is small compared with sr.  The fillet radius centre is taken 
    // to be on a tangent to the spoke circle, which is not strictly true.
    //
    // a  = angle of segment
    // sr = radius of segment
    // t  = thickness of segment
    // fr = fillet radius
    //
    p1 = [fr / tan(a/2), fr] ;
    p2 = [sr - fr,       fr] ;
    p3 = [p1.x + (p2.x-p1.x)*cos(a), p1.y + (p2.x-p1.x)*sin(a)] ;
    union() {
        // inner wedge (extends to full radius)
        translate([p1.x, p1.y, 0])
            segment(a, sr-p1.x, t) ;
        // outer wedge, removing apex
        difference() {
            segment(a, sr - fr, t) ;
            cylinder(r=p1.x, h=2*(t+delta), center=true, $fn=32) ;
        }
        // p1 fillet
        translate([p1.x, p1.y, 0])
            cylinder(r=fr, h=t, center=false, $fn=16) ;
        // p2 fillet
        translate([p2.x, p2.y, 0])
            cylinder(r=fr, h=t, center=false, $fn=16) ;
        // p3 fillet
        translate([p3.x, p3.y, 0])
            cylinder(r=fr, h=t, center=false, $fn=16) ;
    }
}
////-segment_rounded(a, sr, t, fr) triple instance
// for (a=[0,120,240]) rotate([0,0,a]) segment_rounded(110, 20, 5, 2) ;


module hub_segment(a, hr, sr, t) {
    // Circle segment in X-Y plane with hub removed.
    //
    // NOTE: only works for angles up to 180 degrees.
    //
    // a  = angle of segment
    // hr = radius of hub
    // sr = radius of segment
    // t  = thickness of segment
    //
    difference() {
        segment(a, sr, t) ;
        translate([0, 0, -delta])
            cylinder(r=hr, h=t+2*delta, center=false, $fn=24) ;
    }
}
////-hub_segment(a, hr, sr, t) instance
// hub_segment(60, 8, 20, 5) ;


module hub_segment_rounded(a, hr, sr, t, fr) {
    // Circle segment in X-Y plane with hub removed and rounded corners
    //
    // NOTE: only works for angles up to 180 degrees.
    //
    // a  = angle of segment
    // hr = radius of hub
    // sr = radius of segment
    // t  = thickness of segment
    // fr = fillet radius for rounded corners
    //
    bhf1 = asin(fr/(hr+fr)) ;   // Angle to first hub fillet radius centre
    bhf2 = a - bhf1 ;           // Angle to second hub fillet radius centre
    bsf1 = asin(fr/(sr-fr)) ;   // Angle to first segment end fillet radius centre
    bsf2 = a - bsf1 ;           // Angle to second segment end fillet radius centre
    p1 = [fr / tan(a/2), fr] ;
    p2 = [(sr-fr)*cos(bsf1), fr] ;
    p3 = [(sr-fr)*cos(bsf2), (sr-fr)*sin(bsf2)] ;
    p4 = [(hr+fr)*cos(bhf1), fr] ;
    p5 = [(hr+fr)*cos(bhf2), (hr+fr)*sin(bhf2)] ;

    union() {
        hub_segment(a, hr+fr, sr-fr, t) ;
        rotate([0,0,bsf1])
            hub_segment(a-2*bsf1, hr+fr, sr, t) ;
        rotate([0,0,bhf1])
            hub_segment(a-2*bhf1, hr, sr, t) ;
        // p2 fillet
        translate([p2.x, p2.y, 0])
            cylinder(r=fr, h=t, center=false, $fn=16) ;
        // p3 fillet
        translate([p3.x, p3.y, 0])
            cylinder(r=fr, h=t, center=false, $fn=16) ;
        // p4 fillet
        translate([p4.x, p4.y, 0])
            cylinder(r=fr, h=t, center=false, $fn=16) ;
        // p5 fillet
        translate([p5.x, p5.y, 0])
            cylinder(r=fr, h=t, center=false, $fn=16) ;
    }
}
////-hub_segment_rounded(a, hr, sr, t, fr) instances
// hub_segment_rounded(110, 8, 20, 5, 2) ;
// for (a=[0,120,240]) rotate([0,0,a]) hub_segment_rounded(100, 8, 20, 5, 2) ;


////////////////////////////////////////////////////////////////////////////////
// Spoked wheel and component shapes
////////////////////////////////////////////////////////////////////////////////

module spoked_wheel_cutout(hr, sr, fr, wt, ns, sw) {
    // Single spoke cutout for spoked wheel in X-Y plane, centred on the origin,
    // with segment edge aligned with (but offset from) X-axis.
    //
    // hr  = Hub radius (actual hub is larger due to fillets)
    // sr  = spoke radius (centre to inside of rim)
    // fr  = fillet radius of spoke cut-outs
    // wt  = thickness of wheel
    // ns  = number of spokes
    // sw  = width of spokes
    //
    as   = 360/ns ;                     // Angle between spokes

    ahs1 = asin((sw/2)/hr) ;            // Angle from spoke centre line to end of spoke meeting with hub
    ahf1 = asin((sw/2+fr)/(hr+fr)) ;    // Angle from spoke centre line to centre of hub fillet
    ahs2 = as - ahs1 ;                  // Angle from spoke centre line to end of next spoke at hub
    ahf2 = as - ahf1 ;                  // Angle from spoke centre line to centre of next hub fillet

    asr1 = asin((sw/2)/sr)  ;           // Angle from spoke centre line to end of spoke meeting with rim
    asf1 = asin((sw/2+fr)/(sr-fr)) ;    // Angle from spoke centre line to centre of rim fillet
    asr2 = as - asr1 ;                  // Angle from spoke centre line to end of next spoke at rim
    asf2 = as - asf1 ;                  // Angle from spoke centre line to centre of next rim fillet

    fh1c = [ cos(ahf1)*(hr+fr), sin(ahf1)*(hr+fr) ] ;   // Hub fillet 1 centre
    fh2c = [ cos(ahf2)*(hr+fr), sin(ahf2)*(hr+fr) ] ;   // Hub fillet 2 centre
    fs1c = [ cos(asf1)*(sr-fr), sin(asf1)*(sr-fr) ] ;   // Rim fillet 1 centre
    fs2c = [ cos(asf2)*(sr-fr), sin(asf2)*(sr-fr) ] ;   // Rim fillet 2 centre

    difference() {
        union() {
            // main part 
            // (the `-fr*sin(ahf1)` is an approximate but close adjustment to meet the 
            // point where the fillet is tangential to the spoke)
            ring_segment(0, as, hr+fr-fr*sin(ahf1), sr-fr-fr*sin(asf1), wt) ;
            // inner ring
            ring_segment(ahf1, ahf2, hr, hr+2*fr, wt) ;
            // outer ring
            ring_segment(asf1, asf2, sr-2*fr, sr, wt) ;
            // fillets
            for (fc=[fh1c, fh2c, fs1c, fs2c])
                translate([fc.x, fc.y, 0])
                    cylinder(r=fr, h=wt, center=false, $fn=32) ;
        }
        // trim off "wings"
        translate([-sr,sw/2-sr,-delta])
            cube(size=[2*sr, sr, wt+2*delta], center=false) ;
        rotate([0,0,as])
            translate([-sr,-sw/2,-delta])
                cube(size=[2*sr, sr, wt+2*delta], center=false) ;
    }
}  
////-spoked_wheel_cutout(hr, sr, fr, wt, ns, sw) instance
// spoked_wheel_cutout(15, 30, 2, 5, 6, 4) ;

module spoked_wheel_cutouts(hr, sr, fr, wt, ns, sw) {
    // Single spoke cutout for spoked wheel in X-Y plane, centred on the origin,
    // with segment edge aligned with (but offset from) X-axis.
    //
    // hr  = Hub radius (actual hub is larger due to fillets)
    // sr  = spoke radius (centre to inside of rim)
    // fr  = fillet radius of spoke cut-outs
    // wt  = thickness of wheel
    // ns  = number of spokes
    // sw  = width of spokes
    //
    as   = 360/ns ;                     // Angle between spokes

    ahs1 = asin((sw/2)/hr) ;            // Angle from spoke centre line to end of spoke meeting with hub
    ahf1 = asin((sw/2+fr)/(hr+fr)) ;    // Angle from spoke centre line to centre of hub fillet
    ahs2 = as - ahs1 ;                  // Angle from spoke centre line to end of next spoke at hub
    ahf2 = as - ahf1 ;                  // Angle from spoke centre line to centre of next hub fillet

    asr1 = asin((sw/2)/sr)  ;           // Angle from spoke centre line to end of spoke meeting with rim
    asf1 = asin((sw/2+fr)/(sr-fr)) ;    // Angle from spoke centre line to centre of rim fillet
    asr2 = as - asr1 ;                  // Angle from spoke centre line to end of next spoke at rim
    asf2 = as - asf1 ;                  // Angle from spoke centre line to centre of next rim fillet

    fh1c = [ cos(ahf1)*(hr+fr), sin(ahf1)*(hr+fr) ] ;   // Hub fillet 1 centre
    fh2c = [ cos(ahf2)*(hr+fr), sin(ahf2)*(hr+fr) ] ;   // Hub fillet 2 centre
    fs1c = [ cos(asf1)*(sr-fr), sin(asf1)*(sr-fr) ] ;   // Rim fillet 1 centre
    fs2c = [ cos(asf2)*(sr-fr), sin(asf2)*(sr-fr) ] ;   // Rim fillet 2 centre

    // Using `render()` here seems to avoid explosion of CSG tree elements in preview
    // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/The_OpenSCAD_Language#render_2    
    render()
        for (i=[0:ns-1])
            rotate([0,0,i*as])
                difference() {
                    union() {
                        // main part 
                        // (the `-fr*sin(ahf1)` is an approximate but close adjustment to meet the 
                        // point where the fillet is tangential to the spoke)
                        ring_segment(0, as, hr+fr-fr*sin(ahf1), sr-fr-fr*sin(asf1), wt) ;
                        // inner ring
                        ring_segment(ahf1, ahf2, hr, hr+2*fr, wt) ;
                        // outer ring
                        ring_segment(asf1, asf2, sr-2*fr, sr, wt) ;
                        // fillets
                        for (fc=[fh1c, fh2c, fs1c, fs2c])
                            translate([fc.x, fc.y, 0])
                                cylinder(r=fr, h=wt, center=false, $fn=32) ;
                    }
                    // trim off "wings"
                    translate([-sr,sw/2-sr,-delta])
                        cube(size=[2*sr, sr, wt+2*delta], center=false) ;
                    rotate([0,0,as])
                        translate([-sr,-sw/2,-delta])
                            cube(size=[2*sr, sr, wt+2*delta], center=false) ;
                }
}
////-spoked_wheel_cutouts(hr, sr, fr, wt, ns, sw) instance
// spoked_wheel_cutouts(hr=15, sr=30, fr=2, wt=5, ns=6, sw=4) ;

module spoked_wheel(hr, sr, or, fr, wt, ns, sw) {
    // Spoked wheel in X-Y plane, centred on the origin.
    //
    // NOTE: there is no axle hole: calling code is expected to include this
    //
    // hr  = Hub radius (actual hub is larger due to fillets)
    // sr  = spoke radius (centre to inside of rim)
    // or  = outside radius of wheel
    // fr  = fillet radius of spoke cut-outs
    // wt  = thickness of wheel
    // ns  = number of spokes
    // sw  = width of spokes
    //
    // as   = 360/ns ;                     // Angle between spokes
    difference() {
        wheel(or, wt) ;
        translate([0,0,-delta])
            spoked_wheel_cutouts(hr, sr, fr, wt+2*delta, ns, sw) ;
    }
}
////-spoked_wheel(hr, sr, or, fr, wt, ns, sw) instance
// spoked_wheel(hr=8, sr=16, or=20, fr=2, wt=5, ns=5, sw=4) ;


////////////////////////////////////////////////////////////////////////////////
// Triangular structure reinforcing webs
////////////////////////////////////////////////////////////////////////////////

module web_base(w_x, w_y, w_t) {
    // Web with corner on origin, extending along +ve X and Y axes
    // Slight negative x- and y- overlap forces merge with existing shape
    linear_extrude(height=w_t, center=true) {
        polygon(
            points=[
                [-delta, -delta], [-delta, w_y],
                [0, w_y], [w_x, 0],
                [w_x, 0], [w_x, -delta],
                ],
            paths=[[0,1,2,3,4,5,0]]
            ) ;
    }
}

module web_oriented(w_x, w_y, w_t) {
    // Web with corner on origin, extending along +ve or -ve X and Y axes
    if (w_x >= 0)
        {
        if (w_y >= 0)
            {
                web_base(w_x, w_y, w_t) ;
            }
        else // w_y < 0
            {
                // flip through x-z plane: reverse y-axis
                mirror(v=[0,1,0]) web_base(w_x, -w_y, w_t) ;
            }
        }
    else // w_x < 0
        {
        if (w_y >= 0)
            {
                // flip through y-z plane: reverse x-axis
                mirror(v=[1,0,0]) web_base(-w_x, w_y, w_t) ;
            }
        else // w_y < 0
            {
                // flip through x-z and y-z planes: reverse x- and y- axes
                mirror(v=[1,1,0]) web_base(-w_x, -w_y, w_t) ;
            }
        }
 }

module web_xz(x, y, z, w_x, w_z, w_t) {
    // Web in X-Z plane, outer corner at x, y, z
    if (y >= 0) {
        // Rotate around X maps Y to Z, Z to -Y (???)
        translate([x, y - w_t/2, z]) rotate([90,0,0]) web_oriented(w_x, w_z, w_t) ;
    }
    else { // y < 0
        translate([x, y + w_t/2, z]) rotate([90,0,0]) web_oriented(w_x, w_z, w_t) ;
    }
}



////////////////////////////////////////////////////////////////////////////////
// Dovetail interlocking shapes  
////////////////////////////////////////////////////////////////////////////////
//
// (NOTE: need to be printed flat on baseplate if end is wider than shoulder)

module dovetail_key(l, ws, we, t) {
    // Shape for dovetail key, shoulder centre on origin, key extending along -X axis
    // lying on X-Y plane.
    //
    // l  = length from shoulder to end of dovetail
    // ws = width of key at shoulder
    // we = width of key at end
    // t  = thickness of key
    //
    linear_extrude(height=t, center=false) {
        polygon(
            points=[
                [0, ws/2],  [0, -ws/2],
                [-l, we/2], [-l, -we/2]
                ],
            paths=[[0,2,3,1,0]]
            ) ;
    }
}

module dovetail_socket_cutout(l, ws, we, t) {
    // Shape to cutout dovetail socket in piece lying on X-Y plane,
    // with key shoulder centre on origin and piece extending in -X direction
    //
    // (Cutout piece extends below and above Z axis)
    //
    // l  = length from shoulder to end of dovetail
    // ws = width of key at shoulder
    // we = width of key at end
    // t  = thickness of key piece
    //
    translate([+delta,0,-delta]) {
        dovetail_key(l+delta*2, ws, we, t+delta*2) ;
    }
}

module dovetail_tongue_cutout(l, ws, we, wp, t) {
    // Shape to cutout dovetail tongue in end of piece lying on X-Y plane,
    // with key end centre on origin and extending in +X direction
    //
    // (Cutout piece extends below and above Z axis)
    //
    // l  = length from shoulder to end of dovetail
    // ws = width of key at shoulder
    // we = width of key at end
    // wp = width of piece behind tongue
    // t  = thickness of piece with tongue
    //
    difference() {
        translate([-l/2,0,t/2]) {
            cube(size=[l+delta, wp+delta, t+delta], center=true) ;
        } ;
        dovetail_socket_cutout(l+delta, ws, we, t+delta) ;
    }
}

////////////////////////////////////////////////////////////////////////////////
// Apply bevel to child object(s)
////////////////////////////////////////////////////////////////////////////////

module bevel_x_cutaway(x1, x2, y, z, bw, ba) {
    // Cutaway for X-aligned bevel.
    //
    // x1   = minimum x of bevel extent
    // x2   = maximum x of bevel extent
    // y    = y coordinate of corner to be bevelled
    // z    = z coordinate of corner to be bevelled
    // bw   = width of bevel (distance from original corner to new corners)
    // ba   = angle of bevel (e.g. 45, 135, 225, 315)
    //
    translate([x1,y,z])
        rotate([-ba,0,0])
            translate([0,-bw,-bw/sqrt(2)])
                cube(size=[x2-x1,bw*2,bw]) ;
}

// translate([-10,30,5])
//     # cube(size=[60,20,20]) ;
// bevel_x_cutaway(-10,50,30+20,5+20,5,45) ;
// bevel_x_cutaway(-10,50,30+20,5,5,135) ;
// bevel_x_cutaway(-10,50,30,5,5,225) ;
// bevel_x_cutaway(-10,50,30,5+20,5,315) ;

module bevel_x(x1, x2, y, z, bw, ba) {
    // Apply X-aligned bevel to object(s).
    //
    // x1   = minimum x of bevel extent
    // x2   = maximum x of bevel extent
    // y    = y coordinate of corner to be bevelled
    // z    = z coordinate of corner to be bevelled
    // bw   = width of bevel (distance from original corner to new corners)
    // ba   = angle of bevel (e.g. 45, 135, 225, 315)
    //
    difference() {
        children() ;
        bevel_x_cutaway(x1-delta, x2+delta, y, z, bw, ba) ;
    }
}

// bevel_x(-10,50,30+20,5+20,5,45)
//     bevel_x(-10,50,30+20,5,5,135)
//         bevel_x(-10,50,30,5,5,225)
//             bevel_x(-10,50,30,5+20,5,315)
//                 translate([-10,30,5])
//                     cube(size=[60,20,20]) ;


module bevel_y(y1, y2, x, z, bw, ba) {
    // Apply Y-aligned bevel to object(s).
    //
    // x1   = minimum x of bevel extent
    // x2   = maximum x of bevel extent
    // y    = y coordinate of corner to be bevelled
    // z    = z coordinate of corner to be bevelled
    // bw   = width of bevel (distance from original corner to new corners)
    // ba   = angle of bevel (e.g. 45, 135, 225, 315)
    //
    difference() {
        children() ;
        rotate([0,0,-90])
            bevel_x_cutaway(-y2-delta, -y1+delta, x, z, bw, ba) ;
    }
}

// bevel_y(-10,50, 50+20,5+20,5,45)
//     bevel_y(-10,50, 50+20,5,5,135)
//         bevel_y(-10,50,50,5,5,225)
//             bevel_y(-10,50,50,5+20,5,315)
//                 // Cube:  50,-10,5  to  70,50,25
//                 translate([50,-10,5])
//                     cube(size=[20,50+10,20]) ;

////////////////////////////////////////////////////////////////////////////////
// Helical extrusion of solid object
////////////////////////////////////////////////////////////////////////////////


module helix_extrude(h, r, a, ns) {
    // A transformation that takes a solid object centred on the origin on the 
    // X-Y plane, and uses this to create a helical extrusion along the Z axis 
    // with height h, radius r and angle a.
    //
    // The X-axis of the object is aligned along the helix path, and the Y axis
    // is aligned to Z (the axis of extrusion), such that the top of the shape is 
    // on the outside of the helix.
    //
    // h  = height of extrusion path (the resulting object will be higher by 
    //      approximately the X-dimension of the nobject)
    // r  = radius of the helical path of extrusion
    // a  = angle swept by the helical extrusion path (degrees)
    // ns = number of segments used to make up the extruded object.
    //
    // NOTE: ns must to sufficiently large to allow the desired overlap between
    //       successive objectson  the extrusion path.
    //
    sa = a / ns ;           // swept angle per segment (degrees)
    sr = sa*PI/180 ;        // swept angle per segment (radians)
    sc = r*sr ;             // swept circumference per segment
    sh = h / ns ;           // height increase per segment
    st = atan2(sh,sc) ;     // segment tilt to align with helical path (degrees)
    for(i=[1:ns]) {
        translate([0,0,(i-0.5)*sh])     // Lift
            rotate([0,0,(i-0.5)*sa])        // Rotate
                // Swept object
                translate([r, 0, 0])            // Move out along X-axis
                    rotate([st,0,0])                // Tilt to path of helix
                        rotate([0,90,0])                // align shape with direction of extrusion
                            rotate([0,0,90])                // align shape with direction of extrusion
                                children() ;
    }
}

module tapered_cube(l, w1, w2, h) {
    // Tapered cube (or symmetric prism with trapezoidal cross-section), centred
    // at the origin on the X-Y plane, and extending along the X-axis.
    //
    // l   = length of prism
    // w1  = width of prism at base
    // w2  = width of prism at top
    // h   = height of prism
    //
    rotate([0,-90,0])
        linear_extrude(height=l, center=true) {
            polygon(
                points=[
                    [0, w1/2],  [0, -w1/2],
                    [h, w2/2],  [h, -w2/2]
                    ],
                paths=[[0,1,3,2,0]]
                ) ;
        }
}
////-tapered_cube(l, w1, w2, h) instance
// tapered_cube(20,12,10,4) ;


module tapered_oval(l, r1, r2, h) {
    // Tapered oval lug for creating channel with helix_extrude
    // centred at origin on X-Y plane, extending along X-axis
    //
    // l  = distance between rounded-end centres
    // r1 = radius of rounded end at base
    // r2 = radius of rounded end at top
    // h  = height of lug
    //
    translate([-l/2,0,0]) cylinder(r1=r1, r2=r2, h=h, $fn=16) ;
    translate([+l/2,0,0]) cylinder(r1=r1, r2=r2, h=h, $fn=16) ;
    tapered_cube(l, r1*2, r2*2, h) ;
}
////-tapered_oval(l, r1, r2, h) instance
// tapered_oval(20,6,5,4) ;

// Test helix_extrude
// helix_extrude(h=20, r=20, a=720, ns=36) cylinder(r1=4, r2=3, h=2) ;
// helix_extrude(h=20, r=20, a=720, ns=36) tapered_oval(l=6, r1=4, r2=3, h=2) ;

// Test helical path for lug
// intersection() {
//     helix_extrude(h=20, r=20, a=720, ns=36) tapered_cube(l=8, w1=8, w2=5, h=2) ;
//     translate([0,0,-4-1])
//         cylinder(r=20+2, h=20+(4+1)*2, $fn=72 ) ;
//     
// }


////////////////////////////////////////////////////////////////////////////////
// Bayonette (push/twist) fitting
////////////////////////////////////////////////////////////////////////////////

function deg_to_rad(a) =
    // Convert angle in degrees to radians
    a/180*PI ;

function rad_to_deg(ar) =
    // Convert angle in radians to degrees
    ar*180/PI ;

function segment_length(r, a) =
    // Calculates circumferencial extent of segment
    //
    // r  = radius of segment
    // a  = angle swept by segment (in degrees)
    //
    r*deg_to_rad(a) ; 

function segment_corner_adjustment(rs, a) =
    // Calculates adjustment to enlarge segment towards centere to ensure full
    // overlap with a cylinder on which it is placed
    let (
        ar  = deg_to_rad(a),
        dsc = rs * ar * ar              // Approximating r * sin a * tan a (for small a)
        // _ = echo("segment_chorner_adjustment: rs, ar, dsc", rs, ar, dsc)
    ) dsc ;

function radius_lug_top(dl, hl) = 
    // Get radius for top of lug given radius at base and height of lug
    //
    // Looking here for the largest value that can print without drooping.
    // (hl*1 gives 45-degree overhang)
    dl/2 - hl*0.85 ;

module bayonette_channel_cutout(lm, rm, rlb, rlt, hl, at) {
    // Bayotte fitting channel cutout
    //
    // Centred on the origin and aligned along the Z-axis.  The start of the
    // "push" channel lying on the X-Y plane.
    //
    // lm  = length of mating section of cylinders
    // rm  = radius of mating section of cylinders
    // rlb = radius of base of lug
    // rlt = radius of top of lug
    // hl  = height of lug above mating service (=> depth of channel)
    // at  = angle of twist
    //
    dp  = lm * 0.6 ;                        // Distance for "push" channel
    dt  = lm / 32 ;                         // Distance for "twist" channel
    dc  = 0.0 ;                             // Axial distance for final "click" (half)
    ac = rad_to_deg((rlb+rlt)*0.55/rm) ;    // Angle for final "click"
    ns  = 12 ;                              // Number of segments in twist
    rl  = rm + hl ;                         // Radius to top of lug
    ls  = segment_length(rl, at/ns) ;
    // Values used to extend inner face to fully overlap inner cylinder
    dsc = segment_corner_adjustment(rm, at/ns) ;
    rsc = rm - dsc ;
    intersection() {
        cylinder(r=rm+hl, h=lm, $fn=72 ) ;
        union() {
            translate([rsc,0,dp/2-dt+dc])
                rotate([0,90,0])
                    tapered_oval(l=dp, r1=rlb, r2=rlt, h=hl+dsc) ;
            translate([0,0,dp-dt+dc])
                helix_extrude(h=dt, r=rsc, a=at-ac, ns=ns)
                    tapered_cube(l=ls, w1=rlb*2, w2=rlt*2, h=hl+dsc) ;
            // Round end of channel before final "click"
            rotate([0,0,at-ac])
                translate([rsc, 0, dp])
                    rotate([0,90,0])        // align shape with direction of extrusion
                        rotate([0,0,90])        // align shape with direction of extrusion
                            cylinder(r1=rlb+dc, r2=rlt+dc, h=hl+dsc, $fn=16) ;
            // Final end of channel after "click"
            rotate([0,0,at])
                translate([rsc, 0, dp])
                    rotate([0,90,0])        // align shape with direction of extrusion
                        rotate([0,0,90])        // align shape with direction of extrusion
                            cylinder(r1=rlb+dc, r2=rlt+dc, h=hl+dsc, $fn=16) ;
        }
    }
}

// Test bayonette_channel_cutout
// bayonette_channel_cutout(30, 15, 5, 4, 2, 90) ;


module bayonette_socket(ls, lm, ri, rm, ro, hl, dl, nl) {
    // Bayonette (push/twist) socket in cylindrical tube
    //
    // ls  = overall length of socket tube
    // lm  = length of bayonette mating faces
    // ri  = radius of inside of tube
    // rm  = radius of mating faces
    // ro  = radius of outside of tube
    // hl  = height of locking lug above mating face
    // dl  = diameter of locking lug
    // nl  = number of locking lugs (spaced equally around circumference of mating face)
    //
    al  = 360/nl ;                  // Angle between lugs
    at  = al-30 ;                   // angle of twist
    rlb = dl/2 ;                    // Radius of lug at base
    rlt = radius_lug_top(dl, hl) ;  // Radius of lug at top
    // Values used to extend inner face to fully overlap inner cylinder
    dsc = segment_corner_adjustment(rm, ls) ;
    rsc = rm - dsc ;
    difference() {
        cylinder(r=ro, h=ls, $fn=48) ;
        translate([0,0,-delta]) {
            cylinder(r=ri, h=ls+2*delta, $fn=48) ;
            cylinder(r=rm, h=lm, $fn=48) ;
            for (i=[0:nl-1]) {
                rotate([0,0,al*i])
                    bayonette_channel_cutout(lm, rm, rlb, rlt, hl, at) ;
                }
        }
    }
}

// Test bayonette_socket
// ls = 15 ;
// ro = 25 ;
// translate([0,ro*2+20,ls])
//     rotate([0,180,0])
//         bayonette_socket(ls=ls, lm=12, ri=20, rm=22, ro=ro, hl=2, dl=5, nl=3) ;


module bayonette_plug(lp, lm, ri, rm, ro, hl, dl, nl) {
    // Bayonette (push/twist) socket in cylindrical tube
    //
    // lm  = length of bayonette mating faces
    // lp  = length of bayonette plug tube (not including mating face)
    // ri  = radius of inside of tube
    // rm  = radius of mating faces
    // ro  = radius of outside of tube
    // hl  = height of locking lug above mating face
    // dl  = diameter of locking lug
    // nl  = number of locking lugs (spaced equally around circumference of mating face)
    //
    dp  = lm * 0.6 ;                // Distance for "push" channel
    dt  = lm / 32 ;                 // Distance for "twist" channel
    dc  = 0.4 ;                     // Lug offset for snug fit when twisted shut
    al  = 360/nl ;                  // Angle between lugs
    rlb = dl/2 ;                    // Radius of lug at base
    rlt = radius_lug_top(dl, hl) ;  // Radius of lug at top
    // Basic shell
    difference() {
        union() {
            cylinder(r=ro, h=lp, $fn=32) ;
            cylinder(r=rm, h=lp+lm-clearance, $fn=48) ;
        }
        translate([0,0,-delta]) {
            cylinder(r=ri, h=lp+lm+2*delta, $fn=48) ;
        }
    }
    // Values used to extend inner face to fully overlap inner cylinder
    dsc = segment_corner_adjustment(rm, atan2(dl,rm)) ;
    rsc = rm - dsc ;
    // Locking lugs
    translate([0,0,lp+dp+dt-dc]) {
        for (i=[0:nl-1]) {
            rotate([0,0,al*i])
                translate([rm-dsc,0,0])
                    rotate([0,90,0])
                        cylinder(r1=rlb, r2=rlt, h=hl+dsc, $fn=12) ;
        }
    }
}

// Test bayonette_plug
//
// bayonette_plug(lp=5, lm=10, ri=20, rm=22-clearance, ro=25, hl=2, dl=6, nl=3) ;
// // Add twist handle (along Y axis):
// difference() {
//     rotate([0,0,90]) translate([-25,0,0]) oval(50, 8, 5) ;
//     translate([0,0,-delta]) cylinder(d=40, h=5+delta*2, $fn=48) ;
// }

module bayonette(ls, lp, lm, ri, rm, ro, hl, dl, nl) {
    // Bayonette (push/twist) socket in cylindrical tube
    //
    // ls  = overall length of socket tube
    // lm  = length of bayonette mating faces
    // lp  = length of bayonette plug tube (not including mating face)
    // ri  = radius of inside of tube
    // rm  = radius of mating faces
    // ro  = radius of outside of tube
    // hl  = height of locking lug above mating face
    // dl  = diameter of locking lug
    // nl  = number of locking lugs (spaced equally around circumference of mating face)
    //
    translate([0,ro+10,0]) {
        translate([0,0,ls])
            rotate([0,180,0])
                bayonette_socket(ls=ls, lm=lm, ri=ri, rm=rm, ro=ro, hl=hl, dl=dl, nl=nl) ;
        // Add twist handle (along X axis):
        difference() {
            translate([-25,0,0]) oval(50, 8, 5) ;
            translate([0,0,-delta]) cylinder(d=40, h=5+delta*2, $fn=32) ;
        }
    }
    translate([0,-ro-10,0]) {
        bayonette_plug(lp=lp, lm=lm, ri=ri, rm=rm-clearance, ro=ro, hl=hl, dl=dl, nl=nl) ;
        // Add twist handle (along Y axis):
        difference() {
            rotate([0,0,90]) translate([-25,0,0]) oval(50, 8, 5) ;
            translate([0,0,-delta]) cylinder(d=40, h=5+delta*2, $fn=32) ;
        }
    }
}

// Test bayonette assembly
// bayonette(ls=15, lp=5, lm=10, ri=20, rm=22, ro=25, hl=2, dl=6, nl=3) ;



////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////


