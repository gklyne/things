// Compartments.scad

delta = 0.1 ;         // To force overlap

Drawer_depth = 372 ;
Drawer_width = 244 ;

Compartment_width = 81 ;
Compartment_space = 100 ;
Compartment_l1    = Drawer_depth  ;
Compartment_l2    = 240 ;
Compartment_l3    = Drawer_depth - Compartment_l2 ;
Compartment_w3    = Compartment_width * 2 ;
Compartment_ft    = 0.8 ;   // Thickness of floor
Compartment_st    = 2 ;     // Thickness of sides
Compartment_h     = 35 ;    // Height of sides

Corner_cutout_s   = 4 ;     // Shoulder
Corner_cutout_w   = 22 ;    // Width (& depth) of cutout
Latch_cutout_w1   = 50 ;
Latch_cutout_d1   = 4 ;
Latch_cutout_d2   = 7 ;
Latch_cutout_w2   = 30 ;
Latch_cutout_d3   = 21 ;
Latch_cutout_xc   = Compartment_w3 - Drawer_width/2 ;
Latch_cutout_x1   = Latch_cutout_xc - Latch_cutout_w1/2 ;
Latch_cutout_x2   = Latch_cutout_xc - Latch_cutout_w2/2 ;
Latch_cutout_x3   = Latch_cutout_xc + Latch_cutout_w2/2 ;
Latch_cutout_x4   = Latch_cutout_xc + Latch_cutout_w1/2 ;

// ----- Support -----

module joiner_block(x, y, z) {
    // Define shape for joining a piece split at the X-Z plane
    // - intersect with this shape for one part
    // - difference for the other
    //
    // x, y, z are size of piece to be split
    //
    module key_v() {
        linear_extrude(height=z+2*(delta), center=true)
            polygon(
            [
                [+(x/4-1),+delta],
                [-(x/4-1),+delta],
                [-x/4,    -5],
                [+x/4,    -5],
            ]) ;
    }
    module key_h() {
        rotate([0,90,0])
            linear_extrude(height=x+2*(delta), center=true)
                polygon(
                [
                    [+(z/4-1),+delta],
                    [-(z/4-1),+delta],
                    [-z/4,    -5],
                    [+z/4,    -5],
                ]) ;
    }
    translate([x/2,0,z/2]) {
        translate([0, y/4, 0])
            cube(size=[x+2*delta,y/2,z+2*delta], center=true) ;    
        key_v() ;
        key_h() ;
    }
}

// ----- Compartment 1 -----

module compartment_1_outline() {
    polygon(
    [
        [0,                Corner_cutout_w],
        [Corner_cutout_s,Corner_cutout_w],
        [Corner_cutout_w,Corner_cutout_s],
        [Corner_cutout_w,0],
        [Compartment_width,0],
        [Compartment_width,Compartment_l1],
        [0,Compartment_l1],
    ]) ;
}

module compartment_1() {
    module compartment_inside() {
        offset(r=+3) offset(delta=-(Compartment_st+3)) compartment_1_outline() ;
    }
    module compartment_outside() {
        offset(r=+3) offset(r=-3) compartment_1_outline() ;
    }
    module compartment_sides() {
        difference() {
            compartment_outside() ;
            compartment_inside() ;
        }
    }
    // Result
    linear_extrude(height=Compartment_ft) compartment_outside() ;   // Floor
    linear_extrude(height=Compartment_h)  compartment_sides() ;     // Sides
}

module compartment_1_a() {
    intersection() {
        translate([0,-Compartment_l1/2,0]) compartment_1() ;
        joiner_block(Compartment_width, Compartment_l1, Compartment_h) ;
    }    
}

module compartment_1_b() {
    difference() {
        translate([0,-Compartment_l1/2,0]) compartment_1() ;
        joiner_block(Compartment_width, Compartment_l1, Compartment_h) ;
    }    
}

module compartment_1_split() {
    compartment_1_a() ;
    translate([Compartment_space, Compartment_l1/2, 0])
        compartment_1_b() ;
}

// ----- Compartment 2 -----

module compartment_2_outline() {
    polygon(
    [
        [0,0],
        [0,Compartment_l2],
        [Compartment_width,Compartment_l2],
        [Compartment_width,0],
    ]) ;
}

module compartment_2() {
    module compartment_inside() {
        offset(r=+3) offset(delta=-(Compartment_st+3)) compartment_2_outline() ;
    }
    module compartment_outside() {
        offset(r=+3) offset(r=-3) compartment_2_outline() ;
    }
    module compartment_sides() {
        difference() {
            compartment_outside() ;
            compartment_inside() ;
        }
    }
    // Result
    linear_extrude(height=Compartment_ft) compartment_outside() ;   // Floor
    linear_extrude(height=Compartment_h)  compartment_sides() ;     // Sides
}

module compartment_2_twice() {
    module centred_rotated() {
        rotate([0,0,90])
            translate([-Compartment_width/2,-Compartment_l2/2,0])
                compartment_2() ;
    }
    translate([Compartment_l2/2,Compartment_width/2,0]) 
        centred_rotated() ;
    translate([Compartment_l2/2,Compartment_width/2+Compartment_space,0]) 
        centred_rotated() ;
}


// ----- Compartment 3 -----

    module compartment_3_outline() {
        polygon(
        [
            [0,0],
            [0,Compartment_l3],
            [Compartment_w3,Compartment_l3],
            [Compartment_w3,                Corner_cutout_w],
            [Compartment_w3-Corner_cutout_s,Corner_cutout_w],
            [Compartment_w3-Corner_cutout_w,Corner_cutout_s],
            [Compartment_w3-Corner_cutout_w,0],
            [Latch_cutout_x4,0],
            [Latch_cutout_x4,Latch_cutout_d1],
            [Latch_cutout_x3,Latch_cutout_d2],
            [Latch_cutout_x3,Latch_cutout_d3],
            [Latch_cutout_x2,Latch_cutout_d3],
            [Latch_cutout_x2,Latch_cutout_d2],
            [Latch_cutout_x1,Latch_cutout_d1],
            [Latch_cutout_x1,0],
        ]) ;
    }

module compartment_3() {
    module compartment_inside() {
        offset(r=+3) offset(delta=-(Compartment_st+3)) compartment_3_outline() ;
    }
    module compartment_outside() {
        offset(r=+3) offset(r=-3) compartment_3_outline() ;
    }
    module compartment_sides() {
        difference() {
            compartment_outside() ;
            compartment_inside() ;
        }
    }
    // Result
    linear_extrude(height=Compartment_ft) compartment_outside() ;   // Floor
    linear_extrude(height=Compartment_h)  compartment_sides() ;     // Sides
}

// ----- Layouts -----

// compartment_3_outline() ;
// joiner_block(Compartment_width, Compartment_l1, 35) ;

// compartment_1() ;
// compartment_1_a() ;
// compartment_1_b() ;
// compartment_1_split() ;
// compartment_2() ;
// compartment_2_twice() ;
compartment_3() ;



