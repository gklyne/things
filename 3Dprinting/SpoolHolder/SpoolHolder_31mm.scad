use <SpoolHolder.scad>

axledia = 8+0.25;

// Lay down 2-off 31mm hubs and spacers
for (x = [-25,25])
{
    translate([x,0,0])
    {
        SpoolHolder(31+6, 3, 31, 18, axledia, 5);
        translate([0,30,0]) SpoolSpacer(axledia, 18);
        translate([0,-30,0]) SpoolSpacer(axledia,18);
    }
}

