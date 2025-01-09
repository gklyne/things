// Torus.scad

module torus(ir, rr, $fn=$fn) {
	// Torus centred on origin.
	//
	// ir 		inside (hole) radius
	// rr 		rim radius
	//
	rotate_extrude($fn=$fn) {
		translate([ir+rr,0,0])
			circle(r=rr, $fn=32) ;
	}
}

//torus(20, 10);

