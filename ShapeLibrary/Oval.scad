// oval.scad

// Oval plate on X-Y plane, one radiused end centred on the origin,
// and the other centred at [l,0,0]

module oval(l, w, t) {
    // l is distance between radius end centres
    // w is width of oval (twice end radius)
    // t is thickness of plate
    cylinder(d=w, h=t) ;
    translate([l,0,0])
        cylinder(d=w, h=t) ;
    translate([0,-w/2,0])
        cube(size=[l,w,t]) ;
}

// Example
oval(30,10,2) ;