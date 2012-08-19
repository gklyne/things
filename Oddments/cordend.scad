base_dia=22;
top_dia=5;
inside_dia=2;
height=25;

module cordend(bd, td, id, ht)
{
	tr = td/2;
	br = bd/2;
	ir = id/2;
	difference()
	{
		cylinder(h=ht, r1=br, r2=tr);
		union ()
		{
			translate([0,0,-5]) { cylinder(h=ht, r1=br, r2=tr); }
			cylinder(h=ht+1,r=ir);
		}
	}
}

// construct object now
cordend(base_dia, top_dia, inside_dia, height);
