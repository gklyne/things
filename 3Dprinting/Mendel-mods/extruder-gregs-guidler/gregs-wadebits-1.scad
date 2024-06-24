// Greg's Wade Gears.
// It is licensed under the Creative Commons - GNU GPL license. 
// � 2010 by GregFrost
// Parametric extruder gears based on prusa git repo.
// http://www.thingiverse.com/thing:6713

include <configuration.scad>
use <inc/parametric_involute_gear_v5.0.scad>

translate([55,40,0]) 
WadesL(); //this module call will make the large gear
translate([15,60,0]) 
WadesS(); //this module call will make the small gear

module WadesL(){
	num_holes=7;
	hole_size=6;
	hole_offset=18.5;
	gear_thickness=5;
	nut_trap_depth=3;
	nut_trap_thickness=6;

	difference(){
		gear (number_of_teeth=43,
			circular_pitch=268,
			gear_thickness =gear_thickness,
			rim_thickness = 7,
			rim_width = 3,
			hub_thickness = nut_trap_thickness+nut_trap_depth,
			hub_diameter = 22,
			bore_diameter = 8,
			circles=0);

		translate([0,0,nut_trap_thickness])
		rotate(30)
		cylinder($fn=6,r=m8_nut_diameter/2-0.5,h=nut_trap_depth+1);

color([0,0,1])
		for (hole=[0:num_holes-1])
		{
			rotate([0,0,360/num_holes*hole])
			translate([hole_offset,0,0])
			rotate(10)
			translate([0,0,-1])
			{
				cylinder(r=hole_size,h=gear_thickness+2);
				cube([hole_size,hole_size,gear_thickness+2]);
			}
		}
	}
}

module WadesS(){
	difference(){
		gear (number_of_teeth=10,
			circular_pitch=268,
			gear_thickness = 9,
			rim_thickness = 9,
			hub_thickness = 18,
			hub_diameter = 18,
			bore_diameter = 5.25,
			circles=0);
		translate([0,-5,17])cube([6.2,3,9],center = true);
		translate([0,0,14])rotate([0,90,-90])rotate(30)cylinder(r=1.7,h=20);
		translate([0,-5,14])rotate([0,90,-90])cylinder(r=6.2/2/cos(30),h=3,$fn=6,center=true);
	}
}

