// CircularFillet.scad
//

use <Tube.scad>
use <Torus.scad>

module circular_outside_fillet(d, fr) {
    // Circular radiused fillet, for example around where a cylinder meets a plate
    // The fillet lies on the X-Y plane, centred on the origin, and faces upwards
    //
    // d  = diameter of the circular edge to be filleted
    // fr = fillet radius to use
    //
    difference() {
        tube(id=d, od=d+fr*2, l=fr) ;
        translate([0,0,fr])
            torus(ir=d/2, rr=fr) ;
    }
}


// Example
circular_outside_fillet(d=20,fr=2) ;
