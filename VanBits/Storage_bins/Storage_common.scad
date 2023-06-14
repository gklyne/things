// Storage_common.scad
//
// Storage bin common elements
//

delta = 0.01 ;
sqrt2 = sqrt(2) ;

// -----------------------------------------------------------------------------
// Transformation utility functions and modules
// -----------------------------------------------------------------------------

module flip_x_y() {
    // Transform object along X-axis to one along Y-axis
    mirror(v=[-1,1,0])
        children() ;
}
////-flip_x_y()-
//flip_x_y() translate([50,10,0]) cube(size=[50,20,10]) ;


module flip_x_z() {
    // Transform object Z-axis to X-axis
    mirror(v=[-1,0,1])
        children() ;
}
////-flip_x_z()-
//flip_x_z() cube(size=[50,20,10]) ;


module flip_y_z() {
    // Transform object Z-axis to Y-axis
    mirror(v=[0,-1,1])
        children() ;
}
////-flip_y_z()-
//flip_y_z() cube(size=[50,20,10]) ;


module transform_edge_x_front(x, y) {
    // Transform edge on X axis to front edge at given (x,y) position
    //
    // x    = new X-position for reference point at origin
    // y    = new Y-position for reference point at origin
    //
    translate([x,y,0])
        children() ;
}

module transform_edge_x_back(x, y) {
    // Transform edge on X axis to back edge at given (x,y) position
    //
    // x    = new X-position for reference point at origin
    // y    = new Y-position for reference point at origin
    //
    translate([x,y,0])
        mirror([0,1,0])
            children() ;
}

module transform_edge_x_left(x, y) {
    // Transform edge on X axis to left edge at given (x,y) position
    //
    // x    = new X-position for reference point at origin
    // y    = new Y-position for reference point at origin
    //
    translate([x,y,0])
        flip_x_y()
            children() ;
}

module transform_edge_x_right(x, y) {
    // Transform edge on X axis to right edge at given (x,y) position
    //
    // x    = new X-position for reference point at origin
    // y    = new Y-position for reference point at origin
    //
    translate([x,y,0])
        mirror([1,0,0])
            flip_x_y()
                children() ;
}


module linear_extrude_x(height) {
    // Perform linear extrusion, then rotate shape so that extruded Z-axis becomes X-axis
    rotate([0,90,0])
        rotate([0,0,90])
            linear_extrude(height=height)
                children() ;    
}

module mitre_cut_x(w,h) {
    // Cutaway leaving mitred end of shape on X-axis
    difference() {
        children() ;
        translate([-delta*2,0,-delta])
            rotate([0,0,45])
                cube(size=[w*2, w*2, h+2*delta]) ;
    }
}

module mitre_cut_y(w,h) {
    // Cutaway leaving mitred end of shape on Y-axis
    difference() {
        children() ;
        translate([0,-delta*2,-delta])
            rotate([0,0,-45])
                cube(size=[w*2, w*2, h+2*delta]) ;
    }
}

module round_off_z(height, r) {
    // Round off corner lying along Z axis
    difference() {
        children() ;
        translate([0,0,-delta])
            difference() {
                translate([-r,-r,0])
                    cube(size=[r*2,r*2,height+delta*2]) ;
                translate([r,r,-delta])
                    cylinder(r=r, h=height+delta*4, $fn=12) ;
            }
    }
}

// -----------------------------------------------------------------------------
// Edge profile utility functions and modules
// -----------------------------------------------------------------------------

module square_edge_outline(w) {
    // 2D outline shape for square bottom edge on X-Y plane
    //
    // w   = width /height of edge
    // b   = height/width of bevel
    //
    polygon(
        [
            [0,0],
            [w,0],
            [w,w],
            [0,w],
            [0,0],
        ]) ;
}


module square_edge_block(l, w) {
    linear_extrude_x(height=l)
        square_edge_outline(w) ;
}
////-square_edge_block(l, w)-
//square_edge_block(50,12) ;
//mitre_cut_y(12, 12)
//    square_edge_block(50,12) ;


module square_edge_cutaway_x(l, w, t) {
    // Cutaway shape for forming square bottom edge along X-axis 
    //
    // l    = length of cutaway
    // w    = width/height of bevel profile cutaway
    // t    = thickness of wall (also used as rounding radius)
    //
    difference() {
        translate([-delta,-t,-t])
            cube(size=[l+delta*2, w, w+t*2]) ;
        translate([-delta*2,0,0]) {
            linear_extrude_x(height=l+delta*4)
                offset(r=t, $fn=12)
                    offset(delta=-t)
                        square_edge_outline(w) ;
        }
    }
}
////-square_edge_cutaway_x(l, w, t)-
//square_edge_cutaway_x(50, 20, 2) ;


module square_edge_off_x(l, w, t) {
    // Cutaway along X axis to square bottom edge profile
    //
    // l    = length of cutaway
    // w    = width/height of bevel profile cutaway
    // t    = thickness of wall (also used as rounding radius)
    //
    difference() {
        children() ;
        square_edge_cutaway_x(l, w, t) ;
    }
}
////-square_edge_off_x(l, w, t)-
//square_edge_off_x(50, 20, 2) cube(size=[50,20,20]) ;

module square_edge_off_y(l, w, t) {
    // Cutaway along Y axis to square edge profile
    //
    // l    = length of cutaway
    // w    = width/height of bevel profile cutaway
    // t    = thickness of wall (also used as rounding radius)
    //
    difference() {
        children() ;
        flip_x_y()
            square_edge_cutaway_x(l, w, t) ;
    }
}
////-square_edge_off_y(l, w, t)-
//square_edge_off_x(50, 20, 2) square_edge_off_y(50, 20, 2) cube(size=[20,50,20]) ;

//round_off_z(20, 2) 
//    square_edge_off_x(50, 20, 2) 
//        square_edge_off_y(50, 20, 2) 
//            cube(size=[20,50,20]) ;


module bevelled_edge_outline(w, b) {
    // 2D outline shape for bevelled bottom edge on X-Y plane
    //
    // w   = width /height of edge
    // b   = height/width of bevel
    //
    polygon(
        [
            [0,b],
            [b,0],
            [w,0],
            [w,w],
            [0,w],
            [0,b],
        ]) ;
}

module bevelled_edge_block(l, w, b) {
    linear_extrude_x(height=l)
        bevelled_edge_outline(w, b) ;
}
////-bevelled_edge_block(l, w, b)-
//bevelled_edge_block(50,12,10) ;

module bevel_end_outline(b) {
    // 2D outline shape for bevel end on X-Y plane
    //
    // b   = height/width of bevel
    //
    polygon(
        [
            [0,0],
            [0,b],
            [b,0],
            [0,0],
        ]) ;
}


module bevel_end_block(l, b) {
    linear_extrude_x(height=l)
        bevel_end_outline(b) ;
}
////-bevel_end_block(l, b)-
//bevel_end_block(2, 10) ;

module bevel_edge_cutaway_x(l, w, b, t) {
    // Cutaway shape for forming bevelled bottom edge along X-axis 
    //
    // l    = length of cutaway
    // w    = width/height of bevel profile cutaway
    // b    = width/height of bevel
    // t    = thickness of wall (also used as rounding radius)
    //
    difference() {
        translate([-delta,-t,-t])
            cube(size=[l+delta*2, w, w+t*2]) ;
        translate([-delta*2,0,0]) {
            linear_extrude_x(height=l+delta*4)
                offset(r=t, $fn=12)
                    offset(delta=-t)
                        bevelled_edge_outline(w, b) ;
        }
    }
}
////-bevel_edge_cutaway_x(l, w, b, t)-
//bevel_edge_cutaway_x(50, 20, 10, 2) ;

module bevel_edge_off_x(l, w, b, t) {
    // Cutaway along X axis to bevelled edge profile
    //
    // l    = length of cutaway
    // w    = width/height of bevel profile cutaway
    // b    = width/height of bevel
    // t    = thickness of wall (also used as rounding radius)
    //
    difference() {
        children() ;
        bevel_edge_cutaway_x(l, w, b, t) ;
    }
}
////-bevel_edge_off_x(l, w, b, t)-
//bevel_edge_off_x(50, 20, 10, 2) cube(size=[50,20,20]) ;


module bevel_edge_off_y(l, w, b, t) {
    // Cutaway along Y axis to bevelled edge profile
    //
    // l    = length of cutaway
    // w    = width/height of bevel profile cutaway
    // b    = width/height of bevel
    // t    = thickness of wall (also used as rounding radius)
    //
    difference() {
        children() ;
        flip_x_y()
            bevel_edge_cutaway_x(l, w, b, t) ;
    }
}
////-bevel_edge_off_y(l, w, b, t)-
//bevel_edge_off_x(50, 20, 10, 2) bevel_edge_off_y(50, 20, 10, 2) cube(size=[20,50,20]) ;

//round_off_z(20, 2) 
//    bevel_edge_off_x(50, 20, 10, 2) 
//        bevel_edge_off_y(50, 20, 10, 2) 
//            cube(size=[20,50,20]) ;

module bevel_edge_off_z(l, w, b, t) {
    // Cutaway along Z axis to bevelled edge profile
    //
    // l    = length (height) of cutaway
    // w    = width of bevel profile cutaway
    // b    = width/height of bevel
    // t    = thickness of wall (also used as rounding radius)
    //
    difference() {
        children() ;
        flip_x_z()
            bevel_edge_cutaway_x(l, w, b, t) ;
    }
}
////-bevel_edge_off_z(l, w, b, t)-
//bevel_edge_off_x(50, 15, 10, 2) bevel_edge_off_z(50, 15, 10, 2) cube(size=[20,50,20]) ;


module round_ended_cylinder(h, r) {
    translate([0,0,r-delta])
        cylinder(r=r, h=h-2*r+2*delta, $fn=12) ;
    translate([0,0,r])
        sphere(r=r, $fn=12) ;
    translate([0,0,h-r])
        sphere(r=r, $fn=12) ;
}
////-round_ended_cylinder(h, r)-
//round_ended_cylinder(20,2) ;


// -----------------------------------------------------------------------------
// Surface utility functions and modules
// -----------------------------------------------------------------------------

module mesh_45_xy(x, y, t, wm, wh) {
    // A 45 degree mesh on the X-Y plane, centered on the origin
    //
    // x    = overall X-dimension of the mesh
    // y    = overall Y-dimension of the mesh
    // t    = thickness of the mesh
    // wm   = width of the mesh strips
    // wh   = width of holes between the strips
    //
    lm  = x + y ;                       // Over-length of mesh strips
    pm  = wm+wh ;                       // Diagonal mesh pitch
    pxy = pm/sqrt2 ;                    // X/Y direction half-pitch of mesh
    nm  = floor(max(x,y)/pxy) ;         // Number of mesh strips
    bm  = pxy*nm ;                      // Mesh bounds (X and Y)
    ny  = ceil((y+pxy*0.9)/(pxy*2)) ;   // Mesh holes to first infill
    shift_x1 = ((ny)%2)*pxy ;
    shift_x2 = pxy - shift_x1 ;
    shift_y1 = (ny-1)*pxy ;
    shift_y2 = (ny)*pxy ;

    module strip(dir) {
        rotate([0,0,dir*45])
            translate([0,0,t/2])
                cube(size=[lm,wm,t], center=true) ;
    }

    module infill() {
        translate([0,0,t/2])
            rotate([0,0,45])
                cube(size=[pm, pm, t], center=true) ;
        }

    intersection() {
        translate([0,0,t/2])
            cube(size=[x,y,t], center=true) ;
        union() {
            for (o=[-bm : pxy*2 : bm]) {
                translate([o, 0, 0]) strip(+1) ;
                translate([o, 0, 0]) strip(-1) ;
                // Infill top rows of mesh holes, to maintain 45 degree print overhang
                translate([o+shift_x1, shift_y1, 0]) infill() ;
                translate([o+shift_x2, shift_y2, 0]) infill() ;
            }
            //mesh_45_xy_top_infill(x, y, t, wm, wh) ;
        }
    }
}
////-mesh_45_xy(x, y, t, wm, wh)-
//mesh_45_xy(60, 62, 2, 2, 6) ;


module mesh_45_xz(x, z, t, wm, wh) {
    // A 45 degree mesh on the X-Z plane, centered on the origin, 
    // thickness extending in +Y direction
    //
    // x    = overall X-dimension of the mesh
    // z    = overall Z-dimension of the mesh
    // t    = thickness of the mesh
    // wm   = width of the mesh strips
    // wh   = width of holes between the strips
    //
    flip_y_z()
        mesh_45_xy(x, z, t, wm, wh) ;
}
////-mesh_45_xz(x, z, t, wm, wh)-
//mesh_45_xz(50, 30, 2, 2, 5) ;


module mesh_45_yz(y, z, t, wm, wh) {
    // A 45 degree mesh on the Y-Z plane, centered on the origin, 
    // thickness extending in +X direction
    //
    // y    = overall Y-dimension of the mesh
    // z    = overall Z-dimension of the mesh
    // t    = thickness of the mesh
    // wm   = width of the mesh strips
    // wh   = width of holes between the strips
    //
    flip_x_z()
        mesh_45_xy(z, y, t, wm, wh) ;
}
////-mesh_45_yz(y, z, t, wm, wh)-
//mesh_45_yz(50, 30, 2, 2, 5) ;

// -----------------------------------------------------------------------------
// Edge shape elements
// -----------------------------------------------------------------------------

module bottom_edge_x_square(l, w, t) {
    // Bottom square edge on X-axis, facing towards +Y axis 
    //
    // l   = length of edge
    // w   = width /height of edge
    // t   = thickness of walls
    //
    linear_extrude_x(height=l)
        difference() {
            offset(r=t, $fn=12)
                offset(delta=-t)
                    square_edge_outline(w) ;
            offset(delta=-t)
                square_edge_outline(w*2) ;
        }
}
////-bottom_edge_x_square(l, w, t)-
//bottom_edge_x_square(50, 12, 2) ;


module bottom_edge_x_bevel(l, w, b, t) {
    // Bottom bevelled edge on X-axis, facing towards +Y axis 
    //
    // The outside square of the edge (before bevelling) lies on the X axis
    //
    // l   = length of edge
    // w   = width /height of edge
    // b   = height/width of bevel
    // t   = thickness of walls
    //
    linear_extrude_x(height=l)
        difference() {
            offset(r=t, $fn=12)
                offset(delta=-t)
                    bevelled_edge_outline(w, b) ;
            offset(delta=-t)
                bevelled_edge_outline(w*2, b) ;
        }
}
////-bottom_edge_x_bevel(l, w, b, t)-
//bottom_edge_x_bevel(50, 20, 10, 2) ;


module bottom_edge_x_square_bevel(ls, lb, w, b, t) {
    // Bottom square-to-bevelled transition edge on X-axis, facing towards +Y axis
    //
    // ls  = length of square edge (thickness of bevel end is included)
    // lb  = length of bevelled edge
    // w   = width /height of edge
    // b   = height/width of bevel
    // t   = thickness of walls
    //
    bottom_edge_x_square(ls, w, t) ;
    translate([ls-t,0,0]) {
        linear_extrude_x(height=t)
            offset(r=t, $fn=12)
                offset(delta=-t)
                    bevel_end_outline(b+t) ;
        bottom_edge_x_bevel(lb+t, w, b, t) ;
    }
}
////-bottom_edge_x_square_bevel(ls, lb, w, b, t)-
//bottom_edge_x_square_bevel(30, 20, 20, 10, 2) ;


module bottom_edge_x_bevel_square(lb, ls, w, b, t) {
    // Bottom bevelled-to-square transition edge on X-axis, facing towards +Y axis
    //
    // lb  = length of bevelled edge
    // ls  = length of square edge
    // w   = width /height of edge
    // b   = height/width of bevel
    // t   = thickness of walls
    //
    translate([ls+lb,0,0])
        mirror([1,0,0])
            bottom_edge_x_square_bevel(ls, lb, w, b, t) ;
}
////-bottom_edge_x_bevel_square(l, w, b, t)-
//bottom_edge_x_bevel_square(25, 25, 20, 10, 2) ;


module corner_edge_z_square(h, hb, wx, wy, t) {
    // Corner edge on the Z axis, extending towards +X, +Y axes
    //
    // h    = overall height of corner edge
    // hb   = height of base edge
    // wx   = width of corner in X direction edges
    // wy   = width of corner in Y direction edges
    // t    = thickness of sides
    //
    translate([0,0,hb-t])
        round_off_z(h, t) {
            cube(size=[wx,t,h-hb+t]) ;
            cube(size=[t,wy,h-hb+t]) ;
        }
}
////-corner_edge_z_square(h, hb, wx, wy, t)-
//corner_edge_z_square(60, 10, 10, 10, 2) ;


module corner_edge_z_bevelled(h, w, b, t) {
    // Bevelled corner edge on the Z axis, extending towards +X, +Y axes
    //
    // h    = overall height of corner edge
    // w    = width/height of bottom edges
    // b    = width of bevel
    // t    = thickness of sides
    //
    translate([0,0,w-t])
        flip_x_z()
            bottom_edge_x_bevel(h-w+t, w, b, t) ;

}
////-corner_edge_z_bevelled(h, w, b, t)-
//corner_edge_z_bevelled(60, 15, 10, 2) ;


// -----------------------------------------------------------------------------
// Corner shape elements
// -----------------------------------------------------------------------------

module bottom_corner_xy_square(w, t) {
    // Corner piece joining square bottom edges
    //
    // The corner is located at the origin, with edges extending
    // along +X and +Y axes.
    //
    // w    = width/height of edges
    // t    = thickness of walls
    //
    round_off_z(w, t) {
        square_edge_off_x(w, w, t)
            square_edge_off_y(w, w, t) {
                bottom_edge_x_square(w+delta, w, t) ;
                flip_x_y() bottom_edge_x_square(w, w, t) ;
            }
    }
}
////-bottom_corner_xy_square(w, t)-
//bottom_corner_xy_square(15, 2) ;


module bottom_corner_xy_bevelled(l, w, b, t) {
    // Corner piece joining bevelled bottom edges
    //
    // The projected corner is located at the origin, with 
    // edges extending along +X and +Y axes.
    //
    // l    = length of edges
    // w    = width/height of edges
    // b    = height/width of bevel
    // t    = thickness of walls
    //
    round_off_z(w, t) {
        mitre_cut_x(l+w,w)
            bottom_edge_x_bevel(l+delta, w, b, t) ;
        mitre_cut_y(l+w,w)
            translate([0,l,0])
                rotate([0,0,-90])
                    bottom_edge_x_bevel(l+delta, w, b, t) ;
    }
}
////-bottom_corner_xy_bevelled(l, w, b, t)-
//bottom_corner_xy_bevelled(30, 15, 10, 2) ;


module bottom_corner_xz_bevelled(w, b, t) {
    // Corner piece joining bevelled X- and Z- edges
    //
    // The projected corner is located at the origin, with 
    // edges extending along +X and +Y axes.
    //
    // w    = width/height of edges
    // b    = height/width of bevel
    // t    = thickness of walls
    //
    bevel_edge_off_z(w, w, b, t) {
        square_edge_off_y(w, w, t)
            bevel_edge_off_x(w, w, b, t) {
                bottom_edge_x_bevel(w, w, b, t) ;
                flip_x_y() bottom_edge_x_square(w, w, t) ;
                flip_x_z() bottom_edge_x_bevel(w, w, b, t) ;
            }
    }
}
////-bottom_corner_xz_bevelled(w, b, t)-
//bottom_corner_xz_bevelled(18, 10, 2) ;


module bottom_corner_yz_bevelled(w, b, t) {
    // Corner piece joining bevelled Y- and Z- edges
    //
    // The projected corner is located at the origin, with 
    // edges extending along +X and +Y axes.
    //
    // w    = width/height of edges
    // b    = height/width of bevel
    // t    = thickness of walls
    //
    bevel_edge_off_z(w, w, b, t) {
        bevel_edge_off_y(w, w, b, t)
            square_edge_off_x(w, w, t) {
                bottom_edge_x_square(w, w, t) ;
                flip_x_y() bottom_edge_x_bevel(w, w, b, t) ;
                flip_x_z() bottom_edge_x_bevel(w, w, b, t) ;
            }
    }
}
////-bottom_corner_yz_bevelled(w, b, t)-
//bottom_corner_yz_bevelled(18, 10, 2) ;



module bottom_corner_xyz_bevelled(w, b, t) {
    // Corner piece joining bevelled bottom and side edges
    //
    // The projected corner is located at the origin.
    //
    // w    = width/height of edges
    // b    = height/width of bevel
    // t    = thickness of walls
    //
    bevel_edge_off_z(w, w, b, t) {
        bevel_edge_off_y(w, w, b, t)
            bevel_edge_off_x(w, w, b, t) {
                bottom_edge_x_bevel(w, w, b, t) ;
                flip_x_y() bottom_edge_x_bevel(w, w, b, t) ;
                flip_x_z() bottom_edge_x_bevel(w, w, b, t) ;
            }
    }
}
////-bottom_corner_xyz_bevelled(w, b, t)-
//bottom_corner_xyz_bevelled(15, 10, 2) ;


module bottom_corner_x_square_y_bevelled(w, b, t) {
    // Corner piece joining square and bevelled bottom edges
    //
    // The projected corner is located at the origin, with 
    // the square edge extending along +X axis, and
    // the bevelled edge extending along the +Y axis.
    //
    // w    = width/height of edges
    // b    = height/width of bevel
    // t    = thickness of walls
    //
    round_off_z(w, t) {
        bevel_edge_off_y(w, w, b, t)
            square_edge_off_x(w, w, t) {
                bottom_edge_x_square(w, w, t) ;
                flip_x_y() bottom_edge_x_bevel(w, w, b, t) ;
            }
    }
}
////-bottom_corner_x_square_y_bevelled(w, b, t)-
//bottom_corner_x_square_y_bevelled(15, 10, 2) ;


module bottom_corner_x_bevelled_y_square(w, b, t) {
    // Corner piece joining square and bevelled bottom edges
    //
    // The projected corner is located at the origin, with 
    // the bevelled edge extending along the +X axis.
    // the square edge extending along +Y axis, and
    //
    // w    = width/height of edges
    // b    = height/width of bevel
    // t    = thickness of walls
    //
    round_off_z(w, t) {
        square_edge_off_y(w, w, t)
            bevel_edge_off_x(w, w, b, t) {
                flip_x_y() bottom_edge_x_square(w, w, t) ;
                bottom_edge_x_bevel(w, w, b, t) ;
            }
    }
}
////-bottom_corner_x_bevelled_y_square(l, w, b, t)-
// bottom_corner_x_bevelled_y_square(15, 10, 2) ;


// -----------------------------------------------------------------------------
// Face elements
// -----------------------------------------------------------------------------


module bottom_face(x, y, w, t) {
    // Bottom face of storage box, excluding edges.
    //
    // x    = overall X dimension of box
    // y    = overall Y dimension of box
    // w    = width of bottom edges
    // t    = thickness of face
    //
    translate([w-t,w-t,0])
        cube(size=[x-w*2+t*2, y-w*2+t*2, t]) ;
}


module side_face_xz(x, z, hb, wl, wr, ht, t) {
    // Side face of storage box, excluding bottom edges.
    //
    // x    = overall X dimension of box
    // z    = overall Z dimension of box
    // hb   = height of bottom corner edge
    // wl   = width of left corner edge
    // wr   = width of right corner edge
    // ht   = height of top edge
    // t    = thickness of face
    //
    wm = 2.5 ;
    wh = 7.5 ;
    mx = x-wl-wr ;
    mz = z-hb-ht ;
    translate([(x+wl-wr)/2,0,(z+hb-ht-t)/2])
        mesh_45_xz(mx+t*2, mz+t+delta, t, wm, wh) ;
    translate([(x+wl-wr)/2,t/2,z-ht/2])
        cube(size=[mx+t*2,t,ht], center=true) ;
}
////-side_face_xz(x, z, hb, wl, wr, ht, t)-
//side_face_xz(80, 61, 15, 15, 5, 2) ;


module side_face_yz(y, z, wb, wr, wl, ht, t) {
    // Side face of storage box, excluding bottom edges.
    //
    // y    = overall Y dimension of box
    // z    = overall Z dimension of box
    // hb   = height of bottom corner edge
    // wl   = width of left corner edge
    // wr   = width of right corner edge
    // ht   = height of top edge
    // t    = thickness of face
    //
    flip_x_y()
        side_face_xz(y, z, wb, wr, wl, ht, t) ;
}


module front_top_edge_cutout_outline(w, h, hc, wc) {
    oc = (h - hc) ;
    hw = w/2 ;
    polygon(
        [
            [-hw,0],
            [ hw,0],
            [ hw,h],
            [ hw-oc,h],
            [ hw-oc-hc,h-hc],
            [ oc+hc-hw,h-hc],
            [ oc-hw,h],
            [-hw,h],
            [-hw,0],
        ]) ;
    
}

module front_top_edge_cutout(w, h, t, ht, hc) {
    translate([0,0,h/2-ht])
        flip_y_z()
            linear_extrude(height=t)
                offset(r=t, $fn=12)
                    offset(delta=-t)
                        front_top_edge_cutout_outline(w, ht, hc, w-(h-hc)/2) ;
}


module side_face_xz_cutout(x, z, hb, wl, wr, ht, hc, t) {
    // Side face of storage box, excluding bottom edges,
    // with lowered front cutout
    //
    // x    = overall X dimension of box
    // z    = overall Z dimension of box
    // hb   = height of base corner edges
    // wl   = width of left corner edge
    // wr   = width of right corner edge
    // ht   = height of top edge (including cutout)
    // hc   = height of cutout lowering top edge
    // t    = thickness of face
    //
    wm = 2.5 ;
    wh = 7.5 ;
    mx = x-wl-wr ;
    mz = z-hb-ht+t ;
    translate([x/2,0,z/2]) {
        translate([0,0,(hb-ht)/2])
            mesh_45_xz(mx+t*2, mz+t+delta, t, wm, wh) ;
    }
    // translate([x/2,0,(z+hb-ht)/2-t]) {
    translate([x/2,0,z/2]) {
        front_top_edge_cutout(mx+t*2, z, t, ht, hc) ;
    }
}
////-side_face_xz_cutout(x, z, hb, wl, wr, ht, hc, t)-
//translate([0,-20,0])
//side_face_xz_cutout(220, 60, 25, 25, 25, 20, 16, 2) ;

// # cube(size=[25,2,60]) ;
// # cube(size=[40,2,25]) ;
// translate([0,-1,60-20])
//     # cube(size=[40,2,20]) ;


// -----------------------------------------------------------------------------
// Sample box
// -----------------------------------------------------------------------------

// Square at back
// Square on right
// Bevelled on left
// Bevelled at left on front
// Square at right of front

module sample_box(wid, dep, hgt) {
    wb = 15 ;
    ht = 6 ;
    b  = 10 ;
    t  = 2 ;
    
    // Bottom
    bottom_face(wid, dep, wb, t) ;

    // Back
    transform_edge_x_back(0, dep) {
        bottom_corner_x_square_y_bevelled(wb, b, t) ;
        corner_edge_z_square(hgt, wb, wb, wb, t) ;
        translate([wb-t,0,0])
            bottom_edge_x_square(wid-wb*2+t*2, wb, t) ;
        side_face_xz(wid, hgt, wb, wb, wb, ht, t) ;
        translate([wid,0,0])
            rotate([0,0,90]) {
                bottom_corner_xy_square(wb, t) ;
                corner_edge_z_square(hgt, w, wb, wb, t) ;
            }
    }

    // Left
    transform_edge_x_left(0, 0) {
        translate([wb,0,0])
            bottom_edge_x_bevel(dep-wb*2+t*2, wb, wb, wb, b, t) ;
        side_face_xz(dep, hgt, wb, wb, wb, ht, t) ;
    }

    // Right
    transform_edge_x_right(wid, 0) {
        translate([wb,0,0])
            bottom_edge_x_square(dep-wb*2+t*2, wb, t) ;
        side_face_xz(dep, hgt, wb, wb, wb, ht, t) ;
    }

    // Front
    transform_edge_x_front(0, 0) {
        bottom_corner_xyz_bevelled(wb, b, t) ;
        corner_edge_z_bevelled(hgt, wb, b, t) ;
        translate([wb-t,0,0]) {
            lb = 30-wb ;
            ls = wid-lb-wb*2+t*2 ;
            bottom_edge_x_bevel_square(lb, ls, wb, b, t) ;
            ////bottom_edge_x_square(wid-wb*2+t*2, wb, t) ;
            }
        side_face_xz(wid, hgt, wb, wb, wb, ht, t) ;
        translate([wid,0,0])
            rotate([0,0,90]) {
                bottom_corner_xy_square(wb, t) ;
                corner_edge_z_square(hgt, wb, wb, wb, t) ;
            }
    }
}
////-sample_box(wid, dep, hgt)-
//sample_box(100, 80, 60) ;
