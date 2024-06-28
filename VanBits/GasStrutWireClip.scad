// GasStrutWireClip.scad
//
// Clip for retaining wire on gas strut supporting lifting roof
//

delta = 0.01 ;

module helixringsegment(r1, r2, sh1, sh2, sn, ns, sw) {
    assert(r2>r1, "helixring: angle r2 must be greater than r1") ;
    translate([r2,0,0])
        rotate([0, -90, 0])
            linear_extrude(height=(r2-r1), center=false)
                polygon(
                    points = [ [0,-sw/2], [sh1,-sw/2], [sh2, sw/2], [0,sw/2] ],
                    paths  = [ [ 0, 1, 2, 3, 0 ] ]
                ) ;
    // cube(size=[h1, h2, r2]) ;
}
////-helixringsegment(r1, r2, h, sn, ns, sw)-
// helixringsegment(10, 12, 20, 10, 20, 3) ;

// Helical ring.  Used as part of wire-retaining hooks.
//
// The helix allows the ring to be printed without support.
//
// The ring has a "flat" end which is normal to the centre axis,
// and a sloping edge that progresses from 0 to "h" around the
// circumference, proceeding anticlockwise as viewed from +Z.
//
// The "flat" end of the ring lies on the X-Y plane, centred on 
// the origin, with the sloping edge progressing in the +Z direction.
//
// r1	= inner radius of ring
// r2   = outer radius of ring
// d1   = inner diameter of ring
// d2   = outer diameter of ring
// h1   = start height of helix
// h2   = end height of helix, overall height of ring ((a2-a1)/pi for 45 degree climb)
// a1   = start angle of ring (zero height)
// a2   = end angle of ring (full height h)
// ns   = number of steps (goes 0 to ns-1)
//

module helixring(r1=0, r2=0, d1=0, d2=0, h1=0, h2=0, a1=0, a2=180, ns=16) {
    r1 = r1 != 0 ? r1 : d1/2 ;      // Use d1 if r1 is zero
    r2 = r2 != 0 ? r2 : d2/2 ;      // Use d2 if r2 is zero
    ar = (a2-a1)*PI/180 ;           // Sweep angle in radians
    sw = r2*ar/ns ;                 // Segment width
    /// assert(a2>a1, "helixring: angle a2 must be greater than a1") ;
    assert(r2>r1, "helixring: angle r2 must be greater than r1") ;
    difference() {
        translate([0,0, 0]) {
            for (sn = [0:ns-1]) {
                a   = a1 + ((sn+0.5)/ns)*(a2-a1) ;
                sh1 = h1 + (sn/ns) * (h2-h1) ;
                sh2 = h1 + ((sn+1)/ns) * (h2-h1) ;
                rotate([0,0,a])
                    helixringsegment(r1, r2, sh1, sh2, sn, ns, sw) ;
            }
        }
    }
}
////-helixring(r1=0, r2=0, d1=0, d2=0, h1=0, h2=0, a1=0, a2=180, ns=16)-
//// helixring(r1=10, r2=12, h2=10*PI, a1=0, a2=180, ns=24) ;
//// helixring(d1=30, d2=32, h1=5, h2=10*PI, a1=0, a2=180, ns=24) ;

// Tube
module tube(id, t, l) {
    //
    // id   = inside diameter
    // t    = wall thickness
    // l    = length
    //
    difference() {
        cylinder(d=id+2*t, h=l, $fn=16) ;
        translate([0,0,-delta])
            cylinder(d=id, h=l+2*delta, $fn=16) ;
    }
}

// Wire clip
module wireclip(cd, ct, cl, hd, ht) {
    // Wire clip printed vertically at XY plane origin.
    //
    // cd   = clip inside diameter
    // ct   = clip thickness
    // cl   = clip length
    // hd   = hook inside diameter    
    // ht   = hook thickness
    //
    hl1 = cl*0.45 ;
    hl2 = cl/24 ;
    difference() {
        tube(cd, ct, cl) ;
        translate([0,cd*0.7,-delta])
            cylinder(d=cd+ct*2, cl+2*delta, $fn=16) ;
    }
    // For better bed adhesion
    translate([-cd/2,-cd*0.2,0])
        cube(size=[cd,cd*0.4,0.2]) ;
    // Wire retainer
    translate([cd/2+hd/2+ct,0,0]) {
        translate([0,0,0])
            helixring(d1=hd, d2=hd+2*ht, h1=hl2, h2=hl1, a1=180+240, a2=180, ns=16) ;
        translate([0,0,cl/2])
            helixring(d1=hd, d2=hd+2*ht, h1=hl2, h2=hl1, a1=180-240, a2=180, ns=16) ;
        translate([0,0,cl/2-delta])
            mirror([0,0,1])
                helixring(d1=hd, d2=hd+2*ht, h1=hl2, h2=hl1, a1=180-240, a2=180, ns=16) ;
        translate([0,0,cl])
            mirror([0,0,1])
                helixring(d1=hd, d2=hd+2*ht, h1=hl2, h2=hl1, a1=180+240, a2=180, ns=16) ;
    }
}
////-wireclip(cd, ct, cl, hd, ht)-
//// wireclip(22, 1.6, 40, 7.5, 1) ;
//// translate([0,20,0])
wireclip(10, 1.2, 32, 6, 1) ;



