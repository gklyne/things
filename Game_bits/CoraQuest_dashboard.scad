module base(sx, sy, sz) {
    cube(size=[sx,sy,sz], center=false);
}

module recess(px, py, pz, sx, sy, sz) {
    translate([px, py, pz])
        cube(size=[sx,sy,sz], center=false);
}

module dashboard() {
    difference() {
        base(129, 105, 10);
        recess(  4, -1, 5,  95, 96, 10);
        recess(  4, 99, 5,  95,  2, 10);
        recess(103,  4, 4,  22, 22, 10);
        recess(103, 29, 4,  22, 22, 10);
        recess(103, 54, 4,  22, 22, 10);
        recess(103, 79, 4,  22, 22, 10);
    }
}

dashboard();
