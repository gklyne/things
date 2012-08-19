
overallheight = 50;
servoheight = 36;
servowidth = 21;
servolength = 41;
servoholepitch = 14;
servoholediam  = 3;
flangeheight = 27;
overalllength = 58; 
flangethickness = 3;
flangelength = (overalllength-servolength)/2;
pocketwallthickness=2;
socketwidth = 10;
socketheight = 2;
socketthickness = 4;
d1=10;	// Extra offset when preventing coincident surfaces
d2=20;	// Extra length to prevent coincident surfaces

// Standing cube: cube stands on z=0, centred over x- and y- axes
module standingcube(x, y, z)
{
	translate([0,0,z/2]) cube([x,y,z], center=true);
}

// Standing cube with pointy hat: 
// cube stands on z=0, centred over x- and y- axes, 
// with negative y-facing edge extended to a 45 degree point aligned with the z axis
module standingcubehatz(x, y, z)
{
	hatsize = x/sqrt(2);
	translate([0,0,z/2])
		union()
		{
			cube([x,y,z], center=true);
			translate([0,-y/2,0]) rotate([0,0,45]) cube([hatsize,hatsize,z], center=true);
		}
}

// Standing cube with pointy hat: 
// cube stands on z=0, centred over x- and y- axes, 
// with negative y-facing edge extended to a 45 degree point aligned with the x axis
module standingcubehatx(x, y, z)
{
	hatsize = z/sqrt(2);
	translate([0,0,z/2])
		union()
		{
			cube([x,y,z], center=true);
			translate([0,-y/2,0]) rotate([0,90,0]) rotate([0,0,45]) cube([hatsize,hatsize,x], center=true);
		}
}

// Teardrop: height, radius
// like basic non-centred cylinder, but with 45 degree point in -y direction
module teardrop(h, r)
{
	union()
	{
		cylinder(h=h, r=r, $fn=8);
		translate([0,-r/sqrt(2),0]) rotate([0,0,45]) standingcube(r, r, h);
	}
}


// Servoholes: length, hole pitch, height, flange length, hole diameter
// @@TODO use reprap teardrop shape
module servoholes(sl, hp, sh, fl, hd)
{
    xo = (sl+fl)/2;
	yo = hp/2;
	for (x = [-xo,xo])
	{
		for (y = [-yo,yo])
		{
			translate([x,y,0]) 
				//cylinder(h=sh,r=hd/2);
				teardrop(sh,hd/2);
		}
	}
	
}

// Servo outline: length, width, height, flange length, flange height, flange thickness
module servooutline(l, w, h, fl, fh, ft)
{
    union()
        {
            standingcube(l, w, h);
            translate([0,0,fh]) standingcube(l+2*fl, w, ft);
        }
}

// Servo: length, width, height, flange length, flange height, flange thickness, hole pitch, hole diameter
module servo(sl, sw, sh, fl, fh, ft, hp, hd)
{
    difference()
        {
            servooutline(sl, sw, sh, fl, fh, ft);
            servoholes(sl, hp, sh, fl, hd);
        }
}

// Cutout:  servo length, servo width, overall height, flange length, flange height, wall thickness
module servocutout(sl, sw, oh, fl, fh, wt)
{
    union()
        {
            standingcube(sl+(wt*2), sw+(wt*2), oh+wt);
            translate([0,0,fh]) standingcube(sl+2*fl, sw+(wt*2), oh+wt-fh);
        }	
}

// Socket hole: servo length, socket width, socket thickness, socket height
//@@TODO make pointy end for reprap printing
module sockethole(sl, sw, st, sh)
{
	translate([0, 0, sh]) standingcubehatx(sl, sw, st);
}

// Pocket: servo length, servo width, flange length, flange height, wall thickness, 
//         hole pitch, hole diameter,
//         socketwidth, socketthickness, socketheight
module servopocket(sl, sw, fl, fh, ft, wt, hp, hd, skw, skt, skh)
{
	difference()
	{
		servocutout(sl,sw,fh,fl,fh,wt);
		translate([0, -d1, wt])
			servooutline(sl,sw+d2,fh+ft+d2,fl,fh,ft);
		servoholes(sl,hp,fh+ft+d2,fl,hd);
		sockethole(sl+d2,skw,skt,skh+wt);
        translate([0,-sw,0])
			standingcube(sl+d2, d2, fh+ft+d2);
	}
}


//standingcubehatz(10,30,50);
//standingcubehatx(50,30,10);
//teardrop(10, 15);
//servoholes(servolength,servoholepitch,servoheight,flangelength,servoholediam);
//servooutline(servolength,servowidth,servoheight,flangelength,flangeheight,flangethickness);
//servo(servolength,servowidth,servoheight,flangelength,flangeheight,flangethickness,servoholepitch,servoholediam);
//servocutout(servolength,servowidth,overallheight,flangelength,flangeheight,pocketwallthickness);
//sockethole(servolength+d2,socketwidth,socketthickness,socketheight+pocketwallthickness);
//servopocket(servolength, servowidth, flangelength, flangeheight, flangethickness,
//            pocketwallthickness, 
//            servoholepitch, servoholediam/2,
//            socketwidth, socketthickness, socketheight);


// Servo pocket oriented for printing
rotate([-90,0,0])
	translate([0,-(servowidth/2+pocketwallthickness),-flangeheight/2])
		servopocket(servolength, servowidth, flangelength, flangeheight, flangethickness,
		            pocketwallthickness, 
		            servoholepitch, servoholediam/2,
		            socketwidth, socketthickness, socketheight);

// ----------------------------------------------

