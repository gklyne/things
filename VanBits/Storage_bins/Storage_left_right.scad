// Storage_left_left.scad

include <Storage_common.scad>

module storage_left_right(wid, dep, hgt, b_wid) {
    wb = 25 ;
    ht = 6 ;
    b  = 21 ;
    t  = 2 ;
    
    // Bottom
    bottom_face(wid, dep, wb, t) ;

    // Back
    transform_edge_x_back(0, dep) {
        bottom_corner_xy_square(wb, t) ;
        corner_edge_z_square(hgt, wb, t) ;
        translate([wb-t,0,0])
            bottom_edge_x_square(wid-wb*2+t*2, wb, t) ;
        side_face_xz(wid, hgt, wb, ht, t) ;
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
        side_face_xz(dep, hgt, wb, ht, t) ;
    }

    // Right
    transform_edge_x_right(wid, 0) {
        translate([wb,0,0])
            bottom_edge_x_square(dep-wb*2+t*2, wb, t) ;
        side_face_xz(dep, hgt, wb, ht, t) ;
    }

    // Front
    transform_edge_x_front(0, 0) {
        bottom_corner_xy_square(wb, t) ;
        corner_edge_z_square(hgt, wb, t) ;
        translate([wb-t,0,0]) {
            ls = wid-b_wid-wb+t ;
            bottom_edge_x_square_bevel(ls, b_wid-wb, wb, b, t) ;
            }
        side_face_xz(wid, hgt, wb, ht, t) ;
        translate([wid,0,0])
            rotate([0,0,90]) {
                bottom_corner_x_square_y_bevelled(wb, b, t) ;
                corner_edge_z_square(hgt, wb, t) ;
            }
    }
}
////-storage_left_right(wid, dep, hgt, b_wid)-
storage_left_right(155, 122, 90, 42) ;
