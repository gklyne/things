// Tube.scad

delta = 0.01 ;

module tube(id, od, l, $fn=24) {
    // Tube aligned along Z axis, standing on X-Y plane, centred on origin
    //
    // id = inside diamater
    // od = outside diameter
    // l  = length (height)
    difference() {
        cylinder(d=od, h=l, $fn=$fn) ;
        translate([0,0,-delta])
            cylinder(d=id, h=l+2*delta, $fn=$fn) ;
    }
}
