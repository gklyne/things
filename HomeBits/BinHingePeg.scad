// BinHingePeg.scad

module coneslice(d1, d2, h, t) {
	// Slice through cone, centred on origin, aligned along X axis
	intersection() {
	    cylinder(d1=d1, d2=d2, h=h) ;
	    cube(size=[d1+d2, t, h*2], center=true) ;
	}
}


cylinder(d=30, h=4) ;
cylinder(d=23, h=10.5) ;
cylinder(d1=18.5, d2=18.0, h=50) ;
for (a=[0,90]) {
	rotate([0,0,a])	
        coneslice(d1=20, d2=19, h=50, t=3) ;
}
