// PotLid.scad
//
// Replacement for plastic lids that used to be provided with foods
// such as Yoghurt, Cream, etc.
//

include <../ShapeLibrary/Tube.scad> ;
include <../ShapeLibrary/Torus.scad> ;

delta = 0.01 ;
clearance = 0.1 ;

module cone_shell(od1,od2,h,t,$fn=24) {
    // Cone-shaped shell, on X-Y plane, centred around origin
    //
    // od1 = outside diameter of shell at base (Z=0)
    // od2 = outside diameter of shell at top (Z=h)
    // h   = height of shell
    // t   = thickness of shell
    //
    difference() {
        cylinder(d1=od1, d2=od2, h=h, $fn=$fn) ;
        translate([0,0,-delta])
            cylinder(d1=od1-2*t, d2=od2-2*t, h=h+2*delta, $fn=$fn) ;
    }
}
////-cone_shell(od1,od2,h,t)
//-cone_shell(20,25,5,1) ;


module segment180(d, a1, a2, t) {
    // Circle segment in X-Y plane, centred on origin extending from angle a1 to a2, 
    // where angles are measured clockwise from +X axis, a2 <= a1+180 (modulo 360).
    // Thus, the resulting segment has a maximum angle of 180 degrees.
    //
    // The thickness is increased by 'delta' to allow use as a cutout or mask.
    //
    // d    = diameter
    // a1   = start angle
    // a2   = end angle
    // t    = thickness of segment (height above X-Y plane)
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

module segments(r,h,n,w) {
    //  Mask for segments of the lid lip
    //
    //  r  = radius of segment mask
    //  h  = height of segment mask (centred at z=0)
    //  n  = number of segments
    //  w  = width of segments at circumference
    //
    subt_a = (w/r * (360/(2*PI))) ;     // Subtended angle of segment
    half_a = subt_a/2 ;

    for (i = [0:n-1]) {
        a = 360/n ;
        rotate( [0,0,i*a] ) {
            translate([0, 0, -h/2]) {
                segment180(r*2,-half_a,+half_a,h) ;
            }
        }
    }
}
////-segments(r,h,n,w)
//-segments(20,4,3,10) ;

module Lip1(id, od, h, lr) {
    torus(ir=id/2-lr, rr=lr, $fn=48) ;
}

module Lip2(id, od, h) {
    t = (od-id) / 2 ;
    union() {
        translate([0,0,0]) {
            cone_shell(od,od-h/2,h/2+delta,t,$fn=48) ;
        }
        translate([0,0,h/2]) {
            cone_shell(od-h/2,od,h/2+delta,t,$fn=48) ;
        }
    }
}

module Lid(id, od, h, t, lr) {
    //
    // id = inside diameter of lid (not including lip)
    // od = outside diameter of lid
    // h  = height of lid
    // t  = thickness of top of lid
    // lr = radius of lip of lid
    //
    union() {
        cylinder(d=od, h=t, $fn=48) ;
        tube(id, od, t+h+delta, $fn=48) ;
        intersection() {
            union() {
                translate([0,0,t+h-lr]) {
                    Lip1(id, od, h, lr) ;
                }
                translate([0,0,t+h]) {
                    Lip2(id, od, h) ;
                }
            }
        segments(r=od/2+(od-id)/2, h=4*h+t*2, n=4, w=od/3) ;
        }
    }
}

////-Lid(id, od, h, t, lr)
//
//-Lid(40, 41, 2.5, 1, 0.3) ;


module CreamPotLid() {
    Lid(87, 88.6, 2.5, 1, 0.5) ;
}
////-CreamPotLid()
CreamPotLid() ;
