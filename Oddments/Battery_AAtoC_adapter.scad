// Battery_AAtoC_adapter.scad
//
// AA cell: 14.5 x 50.5mm
// C  cell: 26.2 x 50
//
// [https://en.wikipedia.org/wiki/List_of_battery_sizes]
//

delta = 0.01 ;

module battery_AA_to_C() {
	difference() {
        cylinder(d=26, h=48) ;
        translate([0,0,-delta])
            cylinder(d=15, h=48+2*delta) ;
	}
}

battery_AA_to_C() ;

