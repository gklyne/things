// Compartments.scad

delta = 0.1 ;         // To force overlap

Drawer_depth = 372 ;
Drawer_width = 244 ;

Compartment_width = 81 ;
Compartment_space = 90 ;
Compartment_l1    = Drawer_depth  ;
Compartment_l2    = 240 ;
Compartment_l3    = Drawer_depth - Compartment_l2 ;
Compartment_w3    = Compartment_width * 2 ;
Compartment_ft    = 1.5 ;   // Thickness of floor
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

Staple_length     = 40 ;
Staple_width      = 20 ;
Staple_peg_d      = 5 ;
Staple_peg_hd     = 5.25 ;   // Diameter of peg hole with clearance

// ----- Support -----

module join_splitter_block(x, y, z) {
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
                [+(x/4+1),+delta],
                [-(x/4+1),+delta],
                [-(x/4-1),    -4],
                [+(x/4-1),    -4],
            ]) ;
    }
    module key_h() {
        rotate([0,90,0])
            linear_extrude(height=x+2*(delta), center=true)
                polygon(
                [
                    [+(z/4+1),+delta],
                    [-(z/4+1),+delta],
                    [-(z/4-1),    -4],
                    [+(z/4-1),    -4],
                ]) ;
    }
    translate([x/2,0,z/2]) {
        translate([0, y/4, 0])
            cube(size=[x+2*delta,y/2,z+2*delta], center=true) ;    
        key_v() ;
        key_h() ;
    }
}


module staple(l,w,t,pd,pl) {
    // Staple for joining split pieces, centred on X-Y plane
    //
    // l  = length (Y-axis) of staple
    // w  = width (X-axis)
    // t  = thickness (Z-axis)
    // pd = diameter of peg
    // pl = length of peg (Z-axis)
    //
    translate([0,0,t/2])
        cube(size=[w,l,t], center=true) ;
    translate([0,+l/2-pd,0])
        cylinder(h=t+pl,d=pd,center=false,$fn=16) ;
    translate([0,-l/2+pd,0])
        cylinder(h=t+pl+delta,d=pd,center=false,$fn=16) ;
}

module staple_cutout(pl,pd) {
    staple(Staple_length,Staple_width,Compartment_ft,pd,pl+delta*2) ;
}

module staple_cutout_floor(x) {
    // Staple holes cutout for floor on Z=0, centred around Y=0
    //
    // x  = X position of centre
    translate([x,0,Compartment_ft+Compartment_ft+delta])
        rotate([0,180,0])
            staple_cutout(Compartment_ft,Staple_peg_hd) ;
}

module staple_cutout_side_l(x,z) {
    // Staple holes cutout for left side, centred around Y=0
    //
    // x  = X position of centre
    // z  = Z position of top
    translate([x+Compartment_ft+Compartment_st+delta,0,z-Staple_width/2])
        rotate([0,-90,0])
            staple_cutout(Compartment_st,Staple_peg_hd) ;
}

module staple_cutout_side_r(x,z) {
    // Staple holes cutout for right side, centred around Y=0
    //
    // x  = X position of centre
    // z  = Z position of top
    translate([x-Compartment_ft-Compartment_st-delta,0,z-Staple_width/2])
        rotate([0,+90,0])
            staple_cutout(Compartment_st,Staple_peg_hd) ;
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

module compartment_1_holes() {
    difference() {
        translate([0,-Compartment_l1/2,0]) compartment_1() ;
        staple_cutout_floor(Compartment_width/4) ;
        staple_cutout_floor(Compartment_width*1/4) ;
        staple_cutout_floor(Compartment_width*3/4) ;
        staple_cutout_side_l(0,Compartment_h) ;
        staple_cutout_side_r(Compartment_width,Compartment_h) ;
    }
}

module compartment_1_a() {
    intersection() {
        compartment_1_holes() ;
        join_splitter_block(Compartment_width, Compartment_l1, Compartment_h) ;
    }
}

module compartment_1_b() {
    difference() {
        compartment_1_holes() ;
        join_splitter_block(Compartment_width, Compartment_l1, Compartment_h) ;
    }    
}

module compartment_1_split() {
    compartment_1_a() ;
    translate([Compartment_space, Compartment_l1/2, 0])
        compartment_1_b() ;
    // Staples for joining parts:
    translate([Compartment_space*2.1,1*30,0]) staple_cutout(Compartment_ft,Staple_peg_d) ;
    translate([Compartment_space*2.1,3*30,0]) staple_cutout(Compartment_ft,Staple_peg_d) ;
    translate([Compartment_space*2.4,1*30,0]) staple_cutout(Compartment_st,Staple_peg_d) ;
    translate([Compartment_space*2.4,3*30,0]) staple_cutout(Compartment_st,Staple_peg_d) ;
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
// join_splitter_block(Compartment_width, Compartment_l1, 35) ;
// staple(30,10,Compartment_ft,5,Compartment_st) ;
// compartment_1() ;
// compartment_1_holes() ;
// compartment_1_a() ;
// compartment_1_b() ;
compartment_1_split() ;
// compartment_2() ;
// compartment_2_twice() ;
// compartment_3() ;



