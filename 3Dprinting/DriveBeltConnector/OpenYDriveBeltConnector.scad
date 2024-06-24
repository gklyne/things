// Open-Y carriage Drive belt connector

use <../ShapeLibrary/Chamfer.scad>
use <../ShapeLibrary/Teardrop.scad>
use <../ShapeLibrary/NutRecess.scad>
//use <../ShapeLibrary/CounterSink.scad>
use <DriveBeltConnector.scad>

// Belt connector base, aLigned with X axis
//
// l   = overall length
// w   = overall width
// d   = overall thickness (depth)
// bw  = belt width
// bd  = belt depth (to extent of teeth)
// hpx = hole pitch X
// hpy = hole pitch Y
// hd  = hole diameter (countersink width twice this)
// naf = nut across faces size
// nt  = nut thickness
//
module OpenYBeltConnectorPlate(l, w, d,  bw, bd,  hpx, hpy, hd,  naf, nt)
{
    delta = 0.1;
    difference()
    {
        translate([-l/2, -w/2, 0]) cube(size=[l, w, d]);
        translate([-l/2-delta, -bw/2, d-bd]) cube(size=[l+delta*2, bw, 10]);
        chamferX([-l/2,bw/2,d], l, bd, 3, delta);
        for ( xo = [-hpx/2, hpx/2])
        {
            for ( yo = [-hpy/2, hpy/2] )
            {
                translate([xo, yo, 0]) 
                {
                    translate([0, 0, nt]) 
                        mirror([0,0,1])
                            nutrecessZ(naf, d*3, 3, d*2);
                    TeardropZ(d, 3, 1);
                }
            }
        }
    }
}


// Extend plate with Y-flag attachment points
module OpenYFlagAttachments(l, w, t, hd)
{
    delta = 0.1;
    angle = -15;
    difference()
    {
        translate([-l/2, -w/2, 0])
            cube(size=[l, w, t]);
        for ( xo = [-1,1])
        {
            # translate([0, 0, 0])
                intersection()
                {
                    # translate([(l/2-10)*xo, w/2, 0])
                        rotate([0,0,angle*xo])
                            translate([-(xo+1)/2*l, -l*0.8, -delta])
                                cube(size=[l, l, t+delta*2]);
                    translate([l/2*xo,0,0])
                        translate([-l/2,-l/2,-delta])
                            cube(size=[l,l,t+delta*2]);
                }
            translate([xo*(l/2-5), w/2-5, -delta]) 
            {
                TeardropZ(t+delta*2, 3, 1, $fn=8);
            }
        }
        //for ( xo = [-(l/2-5), (l/2-5)])
        //{
        //    # translate([xo, w/2-5, -delta]) 
        //    {
        //        TeardropZ(t+delta*2, 3, 1, $fn=8);
        //    }
        //}
    }
}

//OpenYFlagAttachments(60, 30, 4, 3);

module OpenYBeltConnector()
{
    delta = 0.1;
	l  = 60;
    w  = 20;
    fw = 30;
    t  = 5;
    bw = 6;
    bd = 1.5;
    driveoffset = t - bd + 1;		// Height of centre of belt
    translate([0,0,w/2])
    {
        rotate([90,0,0])
        {
            difference()
            {
                union()
                {
                    OpenYBeltConnectorPlate(l, w, t,   bw, bd,   48, 12, 3,   5.5, 2);
                    translate([0,(fw+w)/2-delta,0])
                        OpenYFlagAttachments(l, fw, t, 3);
                    //translate([0,0,driveoffset])
                    //    rotate([0,45,0])
                    //        cube(size=[16, 20, 16], center=true);
                    translate([0,0,driveoffset])
                        rotate([90,0,0])
                            cylinder(r=8, h=20, center=true);
                }
            translate([0,25,driveoffset])
                rotate([90,0,0])
                    cylinder(r=4, h=40, $fn=12);
            }
        }
    }
}

OpenYBeltConnector();

for ( xo = [ -24, 24 ] )
{
    translate([xo, -30, 0]) 
        BeltConnectorClamp(12, 20, 4,  12, 3, 6);
} 
