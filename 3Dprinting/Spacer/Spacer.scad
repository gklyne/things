// od  = outside diameter
// id  = inside diameter
// len = length of spacer
// d   = delta
module spacer(od, id, len, d)
{
    difference()
    {
        cylinder(r=od/2, h=len);
        translate([0,0,-d]) cylinder(r=id/2, h=len+2*d);
    }
}

// Actual objects here

od = 12;
halfpitch = od;
for (xo = [-halfpitch, halfpitch])
{
	for ( yo = [-halfpitch, halfpitch])
	{
		translate([xo, yo, 0])
		spacer(od, 9, 18, 1);
	}
}



