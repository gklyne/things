w = 76;
l = 93;
base_t = 5;
rib_t = 7;
rib_w = 5;
motor_d = 23;
clamp_d = 3.4;
roller_d = 4.4;
slot_l = 4;

module slot(d,l){
	union(){
		cube([l,d,base_t+2], center=true);
		translate([l/2,0,0])cylinder(r=d/2, h=base_t+2, center=true);
		translate([-l/2,0,0])cylinder(r=d/2, h=base_t+2, center=true);
	}
} //slot

//Main
difference(){
	union(){
		//Base plate
		cube([w,l,base_t], center=true);

		//Ribs
		translate([0,(l-rib_w)/2,base_t])cube([w,rib_w,rib_t], center=true);
		translate([0,-13,base_t])cube([w,rib_w,rib_t], center=true);
		translate([24.5,0,base_t])cube([rib_w,l,rib_t], center=true);
		translate([-24.5,0,base_t])cube([rib_w,l,rib_t], center=true);
	} //union

	//Frame cutout
		translate([0,-(l-16)/2,0])cube([20,18+2,base_t+2], center=true);

	//Motor holes
	translate([0,19.5,0])cylinder(r=motor_d/2, h=base_t+2, center=true);
	translate([0,19.5,0]){
		for (i=[1:4]){
			rotate([0,0,45+90*i])translate([20.128,0,0])slot(clamp_d,slot_l);
		}
	}
	
	//Mounting holes
	translate([0,-32.5,0]){
		for (i=[-1,1]){
			for (j=[-1,1]){
				translate([16*i,17/2*j,0])slot(clamp_d,slot_l);
			}
		}
	}
	translate([0,-32.5,0]){
		for (i=[-1,1]){
			for (j=[-1,1]){
				translate([34*i,17/2*j,0])cylinder(r=clamp_d/2, h=base_t+2, center=true);
			}
		}
	}

	//Roller holes
	for (i=[-1,1]){
		translate([34*i,-5.5,0])cylinder(r=roller_d/2, h=base_t+2, center=true);
	}

	//Little holes
	translate([0,23.75,0]){
		for (i=[-1,1]){
			for (j=[-1,1]){
				translate([33*i,11/2*j,0])cylinder(r=clamp_d/2, h=base_t+2, center=true);
			}
		}
	}

} // difference