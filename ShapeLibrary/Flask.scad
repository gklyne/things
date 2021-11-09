// Flask object used to explore compound curve fillet generation 
// (between sphere and cylinder)

include <torus.scad> ;

module sphere_cylinder_fillet(sr, cr, fr) {
    // Assume sphere centered on origin
    fcz = sqrt(sr*sr - cr*cr + 2*fr*(sr-cr)) ;  // Height of fillet/cylinder tangent
    ftz = fcz*(sr/(sr+fr)) ;                    // Height of fillet/sphere tangent
    fh  = fcz-ftz ;                             // Height of fillet
    translate([0,0,fcz]) {
        difference() {
            translate([0,0,-fh/2])
                cube(size=[sr*2, sr*2, fh], center=true) ;
            torus(cr,fr) ;
        }
    }
}

module flask_outline(br, nr, nh) {
    bch = br * cos(40) ;
    difference() {
        translate([0,0,bch]) {
            union() {
                sphere(r=br, $fn=64) ;
                cylinder(r=nr,h=nh, $fn=32) ;
                sphere_cylinder_fillet(br, nr, 5) ;
            }
        }
        translate([0,0,-br])
            cube(size=[nr*2,nr*2,nr*2], center=true) ;
    }    
}

module flask(br, nr, nh, t) {
    difference() {
        flask_outline(br, nr, nh) ;
        translate([0,0,t]) {
            flask_outline(br-t, nr-t, nh) ;
        }
    }
}



// flask_outline(10, 6, 20) ;

flask(20, 10, 30, 1) ;

