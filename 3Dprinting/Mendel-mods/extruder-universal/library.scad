include <parameters.scad>;


// inner and outer product.  Why aren't these standard?!!!?

function ip(v1 = [0,0,0], v2 = [0,0,0]) = v1.x*v2.x + v1.y*v2.y + v1.z*v2.z;

function op(v1 = [0,0,0], v2 = [0,0,0]) = [v1.y*v2.z - v1.z*v2.y, v1.z*v2.x - v1.x*v2.z, v1.x*v2.y - v1.y*v2.x];


// Adjustable slide bearings for 6mm diameter rods mounted using M3 cap screws 18 mm apart.

// The profile for these should be CSG from the parameters, but at the moment it's a dxf.

// Adrian Bowyer 18 December 2010

//*****************************************************************************************************************

// Make an extrusion from the appropriate profile

module bearingProfile(b360=true)
{
	if(b360)
		linear_extrude(file = str(fileroot, "bearing360.dxf"), layer = "0", height = bearing_width, 
			center = true, convexity = 10, twist = 0, $fn=40);
	else
		linear_extrude(file = str(fileroot, "bearing180.dxf"), layer = "0", height = bearing_width, 
			center = true, convexity = 10, twist = 0, $fn=40);
}

// The distance between the 3mm screw centres is 18 mm
// Set mounts negative to get the bearing, positive to define the teardrop angle, > 360 to get circular holes
// Set b360 true for a 360 degree bearing, false for a 180 one.

module adjustable_bearing(b360=true, mounts=-1)
{
	translate([-13,-9,0]) // Centre the shaft on the z axis
	{
		if(mounts>=0)
		{
			union()
			{
				translate([4, -10, 0])rotate(90, [0, 1, 0])
					rotate(-90, [1, 0, 0])
						if(mounts > 360)
							cylinder(r=1.5, h=50, centre = true, $fn=10);
						else
							rotate([0,0,mounts])
								teardrop(r=1.5, h=50,  center=false, teardrop_angle=0, truncateMM=0.5);
				translate([22, -10, 0])rotate(90, [0, 1, 0])
					rotate(-90, [1, 0, 0])
						if(mounts > 360)
							cylinder(r=1.5, h=50, centre = true, $fn=10);
						else
							rotate([0,0,mounts])
								teardrop(r=1.5, h=50,   center=false, teardrop_angle=0, truncateMM=0.5);
			}
		}else
		{
			difference()
			{
		  		bearingProfile(b360);
				translate([4, -10, 0])rotate(90, [0, 1, 0])
					rotate(-90, [1, 0, 0])
						teardrop(r=1.5, h=50,  center=false, teardrop_angle=0, truncateMM=0.5);
				translate([22, -10, 0])rotate(90, [0, 1, 0])
					rotate(-90, [1, 0, 0])
						teardrop(r=1.5, h=50,  center=false, teardrop_angle=0, truncateMM=0.5);
			}
		}
	}
}




/*
  This makes an angled strut in space between two points.  It is parallel to one of the
  coordinate planes, which means that one coordinate of the two endpoints must be the same.
*/

module strut_block(da, db, wide, deep, round=1)
{
	union()
	{
		translate([-wide/2,-deep/2,0])
			cube([wide, deep, sqrt(da*da + db*db)]);
		if(round == 1)
		{
			rotate([90,0,0])
					cylinder(r=wide/2, h=deep,center=true,$fn=20);
			translate([0,0,sqrt(da*da + db*db)])
				rotate([90,0,0])
					cylinder(r=wide/2, h=deep,center=true,$fn=20);
		} else if(round == 2)
		{
			rotate([0,90,0])
					cylinder(r=deep/2, h=wide,center=true,$fn=20);
			translate([0,0,sqrt(da*da + db*db)])
				rotate([0,90,0])
					cylinder(r=deep/2, h=wide,center=true,$fn=20);
		}
	}
}

module strut(p1=[0,0,0], p2=[0,0,1], wide = 10, deep = 5, round=1)
{
	if(abs(p1.x - p2.x) < 0.00001)
	{
		translate(p1)
			rotate([atan2(p2.z - p1.z, p2.y - p1.y), 0, 0])
				rotate([-90,0,0])
					rotate([0,0,90])
						strut_block(p2.y - p1.y, p2.z - p1.z, wide, deep, round);
	} else if(abs(p1.y - p2.y) < 0.00001)
	{
		translate(p1)
			rotate([0,atan2( p2.x - p1.x, p2.z - p1.z), 0])
					strut_block(p2.x - p1.x, p2.z - p1.z, wide, deep);
	} else
	{
		translate(p1)
			rotate([0,0,atan2(p2.y - p1.y, p2.x - p1.x)])
				rotate([0,90,0])
					strut_block(p2.x - p1.x, p2.y - p1.y, wide, deep, round);
	}
}


/*
  These gives either a NEMA  stepper motor or its mounting holes.

  If body is true, you get the motor.  If it is false you get the screw holes and central
  hole needed to mount the motor.  If counterbore is positive and you are generating the mounting holes
  then the screw holes will get fat to accomodate a cap-screw head counterbore mm away from the face 
  of the motor.  For no counterbores, set counterbore negative.

*/

module nema17(body = true, slots = -1, counterbore = -1, hubdepth=50)
{
	color([1,0.4,0.4,1])
	union()
	{
		if(body)
		{
			translate([0, 0, nema17_shaft_length/2 - nema17_shaft_projection - nema17_hub_depth])
				cylinder(r = nema17_shaft/2, h = nema17_shaft_length, center = true, $fn=20);
			translate([0, 0, -nema17_hub_depth])
				cylinder(r = nema17_hub/2, h = nema17_hub_depth*2, center = true, $fn=20);
	
			translate([0, 0, nema17_length/2])
				cube([nema17_square,nema17_square,nema17_length], center = true);
		} else
			translate([0, 0, -hubdepth/2])
				cylinder(r = nema17_hub/2 + 1, h = hubdepth, center = true, $fn=20);

		if(!body)
		{
			union()
			{
				for ( x = [-0.5, 0.5] ) 
				for ( y = [-0.5, 0.5] )
				{
					translate([x*nema17_screws, y*nema17_screws, -20])
						if(slots <= 0)
							cylinder(r = nema17_screw_r, h = 50, center = true, $fn=10);
						else
							cube([slots, nema17_screw_r*2, 50], center=true);
					if(counterbore >= 0)
						translate([x*nema17_screws, y*nema17_screws, -25-counterbore])
							if(slots <= 0)
								cylinder(r = 2*nema17_screw_r, h = 50, center = true, $fn=10);
							else
								cube([slots+2*nema17_screw_r, nema17_screw_r*4,  50], center=true);
				}
			}
		}
	}
}

module nema14(body = true, slots = -1, counterbore = -1, hubdepth=50)
{
	color([1,0.4,0.4,1])
	union()
	{
		if(body)
		{
			translate([0, 0, nema14_shaft_length/2 - nema14_shaft_projection - nema14_hub_depth])
				cylinder(r = nema14_shaft/2, h = nema14_shaft_length, center = true, $fn=20);
			translate([0, 0, -nema14_hub_depth])
				cylinder(r = nema14_hub/2, h = nema14_hub_depth*2, center = true, $fn=20);
	
			translate([0, 0, nema14_length/2])
				cube([nema14_square,nema14_square,nema14_length], center = true);
		} else
			translate([0, 0, -hubdepth/2])
				cylinder(r = nema14_hub/2 + 1, h = hubdepth, center = true, $fn=20);

		if(!body)
		{
			union()
			{
				for ( x = [-0.5, 0.5] ) 
				for ( y = [-0.5, 0.5] )
				{
					translate([x*nema14_screws, y*nema14_screws, -20])
						if(slots <= 0)
							cylinder(r = nema14_screw_r, h = 50, center = true, $fn=10);
						else
							cube([slots, nema14_screw_r*2, 50], center=true);
					if(counterbore >= 0)
						translate([x*nema14_screws, y*nema14_screws, -25-counterbore])
							if(slots <= 0)
								cylinder(r = 2*nema14_screw_r, h = 50, center = true, $fn=10);
							else
								cube([slots+2*nema14_screw_r, nema14_screw_r*4,  50], center=true);
				}
			}
		}
	}
}

module nema11(body = true, slots = -1, counterbore = -1, hubdepth=50)
{
	color([1,0.4,0.4,1])
	union()
	{
		if(body)
		{
			translate([0, 0, nema11_shaft_length/2 - nema11_shaft_projection - nema11_hub_depth])
				cylinder(r = nema11_shaft/2, h = nema11_shaft_length, center = true, $fn=20);
			translate([0, 0, -nema11_hub_depth])
				cylinder(r = nema11_hub/2, h = nema11_hub_depth*2, center = true, $fn=20);
	
			translate([0, 0, nema11_length/2])
				cube([nema11_square,nema11_square,nema11_length], center = true);
		} else
			translate([0, 0, -hubdepth/2])
				cylinder(r = nema11_hub/2 + 1, h = hubdepth, center = true, $fn=20);

		if(!body)
		{
			union()
			{
				for ( x = [-0.5, 0.5] ) 
				for ( y = [-0.5, 0.5] )
				{
					translate([x*nema11_screws, y*nema11_screws, -20])
						if(slots <= 0)
							cylinder(r = nema11_screw_r, h = 50, center = true, $fn=10);
						else
							cube([slots, nema11_screw_r*2, 50], center=true);
					if(counterbore >= 0)
						translate([x*nema11_screws, y*nema11_screws, -25-counterbore])
							if(slots <= 0)
								cylinder(r = 2*nema11_screw_r, h = 50, center = true, $fn=10);
							else
								cube([slots+2*nema11_screw_r, nema11_screw_r*4,  50], center=true);
				}
			}
		}
	}
}


// Pentagon nut that matches a hexagon...

module pentanut(height=2*nutsize, center=false)
{
		linear_extrude(height = height, center = center, convexity = 10, twist = 0)
			polygon(points = [ [0, -pentanutradius],
							[-pentanutradius*sqrt(3), 0], 
							[0, pentanutradius], 
							[pentanutradius*sin(60), pentanutradius*cos(60)], 
							[pentanutradius*sin(120), pentanutradius*cos(120)], 
							], paths=[[0,1,2,3,4]]);
}



// Make a RepRap teardrop with its axis along Z
// If truncated is true, chop the apex; if not, come to a point

// I stole this function from Erik...

// If teardrop_angle is negative, this just gives an ordinary cylinder.  If it is zero or positive, the 
// teardrop is rotated through that angle.  Other arguments are as for the standard cylinder function.

module teardrop_internal(r=1.5, h=20, teardrop_angle=-1, truncateMM=0.5)
{
	if(teardrop_angle < 0)
		cylinder(r=r, h=h, center=false, $fn=max(2*r, 10));
	 else
		rotate([0, 0, teardrop_angle])
			union()
			{
				if(truncateMM > 0)
				{
					intersection()
					{
						translate([truncateMM,0,h/2]) 
							scale([1,1,h])
								cube([r*2.8275,r*2,1],center=true);
						scale([1,1,h]) 
								rotate([0,0,3*45])
									cube([r,r,1]);
					}
				} else
				{
					scale([1,1,h])
						rotate([0,0,3*45])
							cube([r,r,1]);
				}
				cylinder(r=r, h = h, center=false, $fn=max(2*r, 10));
		}
}

module teardrop(r=1.5, h=20, center=false, teardrop_angle=-1, truncateMM=0.5)
{
	if(center)
		translate([0, 0, -h/2])
			teardrop_internal(r=r, h=h, teardrop_angle=teardrop_angle, truncateMM=truncateMM);
	else
		teardrop_internal(r=r, h=h, teardrop_angle=teardrop_angle, truncateMM=truncateMM);
}


// Make a ball-bearing holder cutout

module bearing_holder(radius = 6.5)
{
	union()
	{
		cylinder (h = radius*20, r = radius, center = true, $fn = 20);
		for(i=[0:2])
		{
			rotate([0,0,120*i])
				translate([radius+screwsize/2, 0, 0])
					union()
					{
						cylinder (h = radius*20, r = screwsize/2, center = true, $fn = 20);
						translate([-screwsize, 0, 0])
							cube([2*screwsize, screwsize, radius*20], center = true);
					}
		}
	}
}

// Make a cuboid with a 45 degree top for vertical slots etc

module cen_hat(size)
{
	translate([0, 0, size.x/sqrt(2)])
		union()
		{
			rotate([0, 45, 0])
				cube([size.x, size.y, 5*max(size.x, max(size.y, size.z))], center=true);
			rotate([0, -45, 0])
				cube([size.x, size.y, 5*max(size.x, max(size.y, size.z))], center=true);
		}
}

module hat_cube(size = [1,1,1], center = false)
{
	difference()
	{
		cube(size, center);
		if(center)
			translate([0, 0, size.z/2])
				cen_hat(size);
		else
			translate([size.x/2, size.y/2, size.z])
				cen_hat(size);
	}
}



module rod(length, threaded=false) if (threaded && renderrodthreads) {
	linear_extrude(height = length, center = true, convexity = 10, twist = -360 * length / rodpitch, $fn = fn)
		translate([rodsize * 0.1 / 2, 0, 0])
			circle(r = rodsize * 0.9 / 2, $fn = fn);
} else cylinder(h = length, r = rodsize / 2, center = true, $fn = fn);


module rodnut(position, washer) render() translate([0, 0, position]) {
	intersection() {
		scale([1, 1, 0.5]) sphere(r = 1.05 * rodsize, center = true);
		difference() {
			cylinder (h = rodnutsize, r = rodnutdiameter / 2, center = true, $fn = 6);
			rod(rodnutsize + 0.1);
		}
	}
	if (washer == 1 || washer == 4) rodwasher(((position > 0) ? -1 : 1) * (rodnutsize + rodwashersize) / 2);
	if (washer == 2 || washer == 4) rodwasher(((position > 0) ? 1 : -1) * (rodnutsize + rodwashersize) / 2);
}


module rodwasher(position) render() translate ([0, 0, position]) difference() {
	cylinder(r = rodwasherdiameter / 2, h = rodwashersize, center = true, $fn = fn);
	rod(rodwashersize + 0.1);
}


module screw(length, nutpos, washer, bearingpos = -1) union(){
	translate([0, 0, -length / 2]) if (renderscrewthreads) {
		linear_extrude(height = length, center = true, convexity = 10, twist = -360 * length / screwpitch, $fn = fn)
			translate([screwsize * 0.1 / 2, 0, 0])
				circle(r = screwsize * 0.9 / 2, $fn = fn);
	} else cylinder(h = length, r = screwsize / 2, center = true, $fn = fn);
	render() difference() {
		translate([0, 0, screwsize / 2]) cylinder(h = screwsize, r = screwsize, center = true, $fn = fn);
		translate([0, 0, screwsize]) cylinder(h = screwsize, r = screwsize / 2, center = true, $fn = 6);
	}
	if (washer > 0 && nutpos > 0) {
		washer(nutpos);
		nut(nutpos + washersize);
	} else if (nutpos > 0) nut(nutpos);
	if (bearingpos >= 0) bearing(bearingpos);
}


module bearing(position) render() translate([0, 0, -position - bearingwidth / 2]) union() {
	difference() {
		cylinder(h = bearingwidth, r = bearingsize / 2, center = true, $fn = fn);
		cylinder(h = bearingwidth * 2, r = bearingsize / 2 - 1, center = true, $fn = fn);
	}
	difference() {
		cylinder(h = bearingwidth - 0.5, r = bearingsize / 2 - 0.5, center = true, $fn = fn);
		cylinder(h = bearingwidth * 2, r = screwsize / 2 + 0.5, center = true, $fn = fn);
	}
	difference() {
		cylinder(h = bearingwidth, r = screwsize / 2 + 1, center = true, $fn = fn);
		cylinder(h = bearingwidth + 0.1, r = screwsize / 2, center = true, $fn = fn);
	}
}


module nut(position, washer) render() translate([0, 0, -position - nutsize / 2]) {
	intersection() {
		scale([1, 1, 0.5]) sphere(r = 1.05 * screwsize, center = true);
		difference() {
			cylinder (h = nutsize, r = nutdiameter / 2, center = true, $fn = 6);
			cylinder(r = screwsize / 2, h = nutsize + 0.1, center = true, $fn = fn);
		}
	}
	if (washer > 0) washer(0);
}


module washer(position) render() translate ([0, 0, -position - washersize / 2]) difference() {
	cylinder(r = washerdiameter / 2, h = washersize, center = true, $fn = fn);
	cylinder(r = screwsize / 2, h = washersize + 0.1, center = true, $fn = fn);
}


module tooth_gap(height = 10, number_of_teeth = 11, inner_radius = 10, dr = 3,  angle=7)
{
	linear_extrude(height = 2*height, center = true, convexity = 10, twist = 0)
		polygon( points = [
			[pi*inner_radius/(2*number_of_teeth), 0],
			[-pi*inner_radius/(2*number_of_teeth), 0],
			[-2*dr *sin(angle) - pi*inner_radius/(2*number_of_teeth), 2*dr],
			[2*dr *sin(angle) + pi*inner_radius/(2*number_of_teeth), 2*dr],
		], convexity = 3);
}



module gear(height = 10, number_of_teeth = 11, inner_radius = 10, outer_radius = 12, angle=15)
{
	difference()
	{
		cylinder(h = height, r = outer_radius, centre = true);
		for(i = [0:number_of_teeth])
		{
		rotate([0, 0, i*360/number_of_teeth])
			translate([0, inner_radius, 0.5*height])
				tooth_gap(height = height, number_of_teeth = number_of_teeth, inner_radius = inner_radius, 
					dr =  outer_radius - inner_radius,  angle=angle);
		}
	}
}

module grub_gear(hub_height=7.5, hub_radius = 9.5, shaft_radius = 2.5, height =13, number_of_teeth = 8, inner_radius = 4.5, outer_radius = 6.5, angle=40)
{
	difference()
	{
		union()
		{
			translate([0,0,0])
				gear(height =height, number_of_teeth = number_of_teeth, inner_radius = inner_radius, 
					outer_radius = outer_radius, angle=angle);
			translate([0,0,-hub_height/2])
				cylinder(h = hub_height, r = hub_radius,center=true,$fn=20);
		}
		
		cylinder(h = 30, r = shaft_radius, center=true,$fn=20);
		
		translate([shaft_radius + 2, 0, -5])
			hat_cube([2.7,5.5,10], center=true);
		translate([0,0,-3.75])
			rotate([0,90,0])
				if(hub_radius >= outer_radius)
					teardrop(h = 2*hub_radius, r = screwsize/2, center=false, teardrop_angle=0, truncateMM=0.5);
				else
					rotate([0,0,180])
						teardrop(h = 2*hub_radius, r = screwsize/2, center=false, teardrop_angle=0, truncateMM=0.5);
	}
}


//grub_gear();

//gear();



//rod(20);
//translate([rodsize * 2.5, 0, 0]) rod(20, true);
//translate([rodsize * 5, 0, 0]) screw(10, true);
//translate([rodsize * 7.5, 0, 0]) bearing();
//translate([rodsize * 10, 0, 0]) rodnut();
//translate([rodsize * 12.5, 0, 0]) rodwasher();
//translate([rodsize * 15, 0, 0]) nut();
//translate([rodsize * 17.5, 0, 0]) washer();

//hat_cube(size=[2,40,2], center=false);

//bearing_holder();

//teardrop(r=15, h=20, center=true, teardrop_angle=-1, truncateMM=0.5);


//pentanut(height=2*nutsize,center=true);


//nema17(body = false, counterbore = 8, hubdepth=10);

//nema11(body = false, counterbore = 8);
//strut(p1=[20,10,20], p2=[20, 60, 40], wide=10, deep=5, round=2);


//adjustable_bearing(true, false);
