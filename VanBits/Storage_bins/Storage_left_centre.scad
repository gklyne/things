// Storage_left_left.scad

include <Storage_common.scad>

module storage_left_center(wid, dep, hgt, ht, hc) {
    wb = 25 ;
    t  = 2 ;
    
    // Bottom
    bottom_face(wid, dep, wb, t) ;

    // Back
    transform_edge_x_back(0, dep) {
        bottom_corner_xy_square(wb, t) ;
        corner_edge_z_square(hgt, wb, t) ;
        translate([wb-t,0,0])
            bottom_edge_x_square(wid-wb*2+t*2, wb, t) ;
        side_face_xz(wid, hgt, wb, ht-hc, t) ;
        translate([wid,0,0])
            rotate([0,0,90]) {
                bottom_corner_xy_square(wb, t) ;
                corner_edge_z_square(hgt, wb, t) ;
            }
    }

    // Left
    transform_edge_x_left(0, 0) {
        translate([wb,0,0])
            bottom_edge_x_square(dep-wb*2+t*2, wb, t) ;
        side_face_xz(dep, hgt, wb, ht-hc, t) ;
    }

    // Right
    transform_edge_x_right(wid, 0) {
        translate([wb,0,0])
            bottom_edge_x_square(dep-wb*2+t*2, wb, t) ;
        side_face_xz(dep, hgt, wb, ht-hc, t) ;
    }

    // Front
    transform_edge_x_front(0, 0) {
        bottom_corner_xy_square(wb, t) ;
        corner_edge_z_square(hgt, wb, t) ;
        translate([wb-t,0,0]) {
            bottom_edge_x_square(wid-wb*2+t*2, wb, t) ;
            }
        //side_face_xz(wid, hgt, wb, ht, t) ;
        side_face_xz_cutout(wid, hgt, wb, ht, hc, t) ;
        translate([wid,0,0])
            rotate([0,0,90]) {
                bottom_corner_xy_square(wb, t) ;
                corner_edge_z_square(hgt, wb, t) ;
            }
    }
}
////-storage_left_center(wid, dep, hgt, ht, hc)-
storage_left_center(228, 140, 60, 25, 20) ;
//storage_left_center(238, 140, 60, 25, 20) ;  // with new side boxes
