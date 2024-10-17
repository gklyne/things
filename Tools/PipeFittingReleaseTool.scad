// PipeFittingReleaseTool.scad

// Tool to facilitate separation of push-fit pipe fittings
// (Such as used in CAMRA beer cooling system)

include <../ShapeLibrary/CommonDmensions.scad> ;

use <../ShapeLibrary/Oval.scad> ;
use <../ShapeLibrary/Tube.scad> ;
use <../ShapeLibrary/CircularFillet.scad> ;
use <../ShapeLibrary/NutRecess.scad> ;

delta = 0.01 ;

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

// ----------

// Tools for composing elements that consist of a specified outer shape and cutaway
//
// Ultimately, the rendered shape if formed from the difference between:
//   1. the union of the outer shapes, and
//   2. the union of the cutaways
//
// The individual shapes cannot be combined so easily as the cutaways may cross
// between multiple sub-assemblies.
//
// Each component consists of a list of 2 elements:
//   1. An outer shape
//   2. A cutaway
//

// @@@@ Hmmm. does =OpenSCAD allow me to create a structure of solids which can be accessed as multiple child elements? @@@@

// ----------



// Countersink infill for nut recess
//
module nut_cs_infill(sd, nut_af, nut_t) {
    sin60 = sin(60);
    difference() {
        // nut blank
        cylinder(d=nut_af/sin60, h=nut_t, $fn=6) ;
        // Countersink cutout
        translate([0,0,nut_t*0.45-delta])
            cylinder(d1=sd, d2=sd+2*nut_t, h=nut_t+2*delta, $fn=12);
        translate([0,0,-delta])
            cylinder(d=sd, h=nut_t+2*delta, $fn=12) ;
    }    
}
nut_cs_infill(m3, m3_nut_af, m3_nut_t) ;

// Screw hole and round reinforcing rib
//
// od       = overall diameter of rib
// sd       = screw diameter
// l        = overall length of screw (height to base of nut recess)
// nut_af   = nut size across faces
// nut_t    = nut thickness
//
module screw_hole_nut_recess_o(od, sd, l, nut_af, nut_t) {
    // Outer housing
    union() {
        cylinder(d=od, h=l, $fn=12) ;
        translate([-od/2, -od/2, 0])
            cube(size=[od/2, od, l]) ;
    }
}
module screw_hole_nut_recess_c(od, sd, l, nut_af, nut_t) {
    // Cutaway
    translate([0,0,l-nut_t-delta]) {
        rotate([0,0,90])
            nutrecessZ(af=nut_af, oh=l+2*delta, sd=sd, sh=l-nut_t) ;
    }
}
module screw_hole_nut_recess(od, sd, l, nut_af, nut_t) {
    difference() {
        screw_hole_nut_recess_o(od, sd, l, nut_af, nut_t) ;
        screw_hole_nut_recess_c(od, sd, l, nut_af, nut_t) ;
    }
}
// screw_hole_nut_recess(od=m3*2.5, sd=m3, l=5, nut_af=m3_nut_af, nut_t=m3_nut_t) ;


// Triangular web in the X-Z plane, centred around Y-axis and with corner at the origin
//
// l = length of web (X-axis)
// h = height of web (Z-axis)
// t = thickness of web (Y-axis)
module web(l, h, t) {
    rotate([90,0,0])
        translate([0,0,-t/2])
            triangle_plate(0,0, l,0, 0,h, t) ;
}



// Triangular web in the X-Z plane, with reinforcing screw housing that can also
// be used to joint pairs of tools for a stronger, double-ended version
//
// l        = length of web (X-axis)
// h        = height of web (Z-axis)
// t        = thickness of web (Y-axis)
// od       = overall diameter of screw housing
// sd       = screw diameter
// nut_af   = nut size across faces
// nut_t    = nut thickness
//
module web_screw_hole_o(l, h, t, od, sd, nut_af, nut_t) {
    translate([t/2,0,0]) {
        web(l, h, t) ;
        translate([od/2,0,0]) {
            screw_hole_nut_recess_o(od, sd, h, nut_af, nut_t) ;
        }
    }
}
module web_screw_hole_c(l, h, t, od, sd, nut_af, nut_t) {
    // Cutaway for screw and nut
    sho = od/2 + t/2 ;  // Screw housing offset
    translate([sho,0,0]) {
        screw_hole_nut_recess_c(od, sd, h, nut_af, nut_t) ;
    }
}
module web_screw_hole(l, h, t, od, sd, nut_af, nut_t) {
    difference() {
        web_screw_hole_o(l, h, t, od, sd, nut_af, nut_t) ;
        web_screw_hole_c(l, h, t, od, sd, nut_af, nut_t) ;
    }
}
// translate([0,20,0])
// web_screw_hole(l=25, h=10, t=2, od=m3*2.5, sd=m3, nut_af=m3_nut_af, nut_t=m3_nut_t) ;


// td = diameter of pipe tools fits
// tl = length of tool cylinder
// tt = thickness of tool cylinder
// fl = length of flange used to push on tool (between centres of rounded ends)
// fw = width of flange
// ft = thickness of flange
//
module pipe_fitting_release_tool_o(td, tl, tt, fl, fw, ft) {
    union() {
        // Flange
        translate([-fl/2,-fw*0.1,0])
            oval(fl, fw, ft) ;
        // Tube section to press on fitting release
        tube(td, td+2*tt, tl) ;
        // Fillet where tube meets flange 
        translate([0,0,ft-delta])
            circular_outside_fillet(d=td+2*tt-delta, fr=2) ;
        // Webs to reinforce plate
        translate([td*0.5,0,0]) {
            web_screw_hole_o(
                fl*0.55, tl*0.6, ft, od=m3*2.5, sd=m3, 
                nut_af=m3_nut_af, nut_t=m3_nut_t
                ) ;
        }
        mirror([1,0,0])
            translate([td*0.5,0,0]) {
                web_screw_hole_o(
                    fl*0.55, tl*0.6, ft, od=m3*2.5, sd=m3, 
                    nut_af=m3_nut_af, nut_t=m3_nut_t
                    ) ;
            }
    }
}
module pipe_fitting_release_tool_c(td, tl, tt, fl, fw, ft) {
    // Uses 'nut_t=m3_nut_t+0.75' in call to 'web_screw_hole_c',
    // to make the nut recess slightly deeper, 
    // allowing shorter screws to be used to attach 2 plates
    union() {
        // Cutaway in flange to fit over tube
        translate([0,0,-delta])
            cylinder(d=td, h=tl+2*delta) ;
        // Cutaway to clip over tube
        translate([0,td*0.7,-delta])
            cylinder(d=td*1.2, h=tl+2*delta) ;
        translate([td*0.5,0,0]) {
            web_screw_hole_c(
                fl*0.55, tl*0.6, ft, od=m3*2.5, sd=m3, 
                nut_af=m3_nut_af, nut_t=m3_nut_t+0.75
                ) ;
        }
        mirror([1,0,0])
            translate([td*0.5,0,0]) {
                web_screw_hole_c(
                    fl*0.55, tl*0.6, ft, od=m3*2.5, sd=m3, 
                    nut_af=m3_nut_af, nut_t=m3_nut_t+0.75
                    ) ;
            }

    }
}
module pipe_fitting_release_tool(td, tl, tt, fl, fw, ft) {
    difference() {
        pipe_fitting_release_tool_o(td, tl, tt, fl, fw, ft) ;
        pipe_fitting_release_tool_c(td, tl, tt, fl, fw, ft) ;
    }
}

// Parameters for 3/8" (9.5mm) pipe diameter
pipe_fitting_release_tool(td=10, tl=10, tt=2, fl=40, fw=18, ft=2) ;



// End.
