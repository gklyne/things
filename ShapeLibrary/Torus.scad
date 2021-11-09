module torus(ir, rr) {
	// Torus centred on origin.
	//
	// ir 		inside (hole) radoius
	// rr 		rim radius
	//
	rotate_extrude($fn=64) {
		translate([ir+rr,0,0])
			circle(r=rr, $fn=32) ;
	}
}

//torus(20, 10);

