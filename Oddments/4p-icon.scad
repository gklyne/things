// 4p-icon.scad

delta = 0.01 ;
clearance = 0.1 ;

module oval(x, d, h) {
    // Oval shape aligned on the X axis, with one end centred on the origin
    //
    // x  = X position of second centre of curvature
    // d  = width of oval, also diameter of curved ends
    // h  = height (thickness) of oval
    //
    cylinder(d=d, h=h, $fn=16) ;
    translate([x,0,0])
        cylinder(d=d, h=h, $fn=16) ;
    translate([x/2,0,h/2])
        cube(size=[x, d, h], center=true) ;
}

module oval_xy(x1, y1, x2, y2, d, h) {
    // Oval shape on the X-Y plane, with ends at the indicated positions
    //
    // x1 = X position of first centre of curvature
    // y1 = Y position of first centre of curvature
    // x2 = X position of second centre of curvature
    // y2 = Y position of second centre of curvature
    // d  = width of oval, also diameter of curved ends
    // h  = height (thickness) of oval
    //
    l = sqrt((x2-x1)^2+(y2-y1)^2) ;     // Length of oval (between radius centres)
    a = atan2(y2-y1,x2-x1) ;            // Angle of oval from X-axis
    translate([x1,y1,0]) {
        cylinder(d=d, h=h, $fn=16) ;
        rotate([0,0,a])
            translate([0,-d/2,0])
                cube(size=[l, d, h], center=false) ;
    }
    translate([x2,y2,0])
        cylinder(d=d, h=h, $fn=16) ;
}
////-oval_xy(x1, y1, x2, y2, d, h) instance
// oval_xy(-20,30,-60,-60,10,5) ;

h1 = 20 ;
h2 = 16 ;
w  = 20 ;
wv = 40 ;
t1 = 1 ;
t2 = 2 ;

translate([-w-2.5, -5, -t1+delta])
    cube(size=[w+10,h1+10,t1]) ;
oval_xy(0,-2.5, 0,h1, 2, t2) ;

for (i = [1,2,3]) {
	x1 = 1 - 4*i ;
	y1 = h2 * (wv+x1)/wv ;
	x2 = x1 - y1*0.4 ;
	y2 = 0 ;
    oval_xy(x1,y1, x2,y2, 2, t2) ;
}


