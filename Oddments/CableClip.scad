
module CableClip(len,wid,hgt,intht,intwd,pitch,holedia)
{
	d2 = intwd-(2*intht);
	d1 = d2/2;
	rotate([-90,0,0]) translate([0,-hgt,0])
		difference()
		{
			// Block
			translate([-0.5*len,0*wid,0*hgt]) cube([len,hgt,wid], center=false);
			// Cable hole
			translate([-d1,0,-wid/2]) cylinder(r=intht,h=wid*2);
			translate([-d1,-intht,-wid/2]) cube([d2,intht*2,wid*2], center=false);
			translate([+d1,0,-wid/2]) cylinder(r=intht,h=wid*2);
			// Screw holes
			translate([-pitch/2,-hgt/2,wid/2]) rotate([-90,0,0]) cylinder(r=holedia/2, h=hgt*2, $fn=8);
			translate([+pitch/2,-hgt/2,wid/2]) rotate([-90,0,0]) cylinder(r=holedia/2, h=hgt*2, $fn=8);
		}
	//translate([-d1,-intht,-wid/2]) cube([d2,intht*2,wid*2], center=false);
	//translate([-pitch/2,-hgt/2,wid/2]) rotate([-90,0,0]) cylinder(r=holedia/2, h=hgt*2, $fs=0.7);
	
}


l = 18;
w = 8;

for (i = [-l, l])
{
	for (j = [-w, w])
	{
		translate([i,j,0]) CableClip(l,w,6, 3,7, 12,3);
	}
}
