// PipeFittingReleaseTool.scad

// Tool to facilitate separation of push-fit pipe fittings
// (Such as used in CAMRA beer cooling system)

use <../ShapeLibrary/Oval.scad> ;
use <../ShapeLibrary/Tube.scad> ;
use <../ShapeLibrary/CircularFillet.scad> ;

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


module web(l, h, t) {
    // Triangular web in the X-Z plane, centred around Y-axis and with corner at the origin
    //
    // l = length of web (X-axis)
    // h = height of web (Z-axis)
    // t = thickness of web (Y-axis)
    rotate([90,0,0])
        translate([0,0,-t/2])
            triangle_plate(0,0, l,0, 0,h, t) ;
}

module pipe_fitting_release_tool(td, tl, tt, fl, fw, ft) {
    // td = diameter of pipe tools fits
    // tl = length of tool cylinder
    // tt = thickness of tool cylinder
    // fl = length of flange used to push on tool (between centres of rounded ends)
    // fw = width of flange
    // ft = thickness of flange
    //
    difference() {
        union() {
            // Flange
            translate([-fl/2,-fw*0.1,0])
                oval(fl, fw, ft) ;
            // Tube section to press on fitting release
            tube(td, td+2*tt, tl) ;
            // Fillet where tube meets flange 
            translate([0,0,ft-delta])
                circular_outside_fillet(d=td+2*tt-delta, fr=1.5) ;
            // Webs to reinforce plate
            translate([td*0.5,0,0])
                web(fl*0.5, tl*0.6, ft) ;
            mirror([1,0,0])
                translate([td*0.5,0,0])
                    web(fl*0.5, tl*0.6, ft) ;
        }
    // Cutaway in flange to fit over tube
    translate([0,0,-delta])
        cylinder(d=td, h=tl+2*delta) ;
    // Cutaway to clip over tube
    translate([0,td*0.7,-delta])
        cylinder(d=td*1.2, h=tl+2*delta) ;
    }
}

// Parameters for 3/8" (9.5mm) pipe diameter





pipe_fitting_release_tool(td=10, tl=10, tt=2, fl=40, fw=17.5, ft=2) ;

