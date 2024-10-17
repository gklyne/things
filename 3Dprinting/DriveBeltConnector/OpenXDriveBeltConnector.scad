// Drive belt connector

use <../ShapeLibrary/NutRecess.scad>
use <../ShapeLibrary/CounterSink.scad>

// Tooth profile, tooth centred on origin
//
// p = pitch (tooth is half this)
// w = width
// h = height of tooth (extra is added at base)
// a = angle of tooth face
//
module Tooth(p, w, h, a)
{
    d = 0.1;
    difference()
    {
        translate([0,0,d/2])
            cube(size=[p, w, h+d], center=true);
        translate([p/4,0,0])
            rotate([0,a,0])
                translate([p/2,0,0])
                    cube(size=[p, w*2, h*4], center=true);
        translate([-p/4,0,0])
            rotate([0,-a,0])
                translate([-p/2,0,0])
                    cube(size=[p, w*2, h*4], center=true);
    }
}

//Tooth(5, 6, 1.2, 20);

// Tooth profile section of length l and width w, 
// Aligned with and centred on X axis, with teeth downwards
// touching X-Y plane
// can be subtracted from object to leave tooth profile.
//
// Per http://www.contitech.de/pages/produkte/antriebsriemen/antrieb-industrie/download/TD_Synchroflex_en.pdf
//   Tooth pitch = 5
//   Tooth andgle between faces = 40%
//   Tooth height = 1.2
//
module ToothProfileX(l, w)
{
    tp = 5;
    th = 1.2;
    ta = 20;
    translate([-l/2-tp/4, -w/2, th]) cube(size=[l+tp/2, w, 10]);
    for ( to = [ -l/2 : tp : l/2 ] )
    {
        translate([to,0,th/2]) Tooth(tp,w,th,ta);
    }
}

//ToothProfileX(80, 6);

// Belt connector base, aligned with X axis
//
// l   = overall length
// w   = overall width
// d   = overall thickness (depth)
// l1  = length attachment prong
// l2  = length locating ridge
// l3  = length belt hole 
// bw  = belt width
// bd  = belt depth (to extent of teeth)
// hpx = hole pitch X
// hpy = hole pitch Y
// hd  = hole diameter (countersink width twice this)
// naf = nut across faces size
// nt  = nut thickness
//
module BeltConnectorBase(l, w, d,  l1, l2, l3, bw, bd,  hpx, hpy, hd,  naf, nt)
{
    union()
    {
        difference()
        {
            translate([-l/2, -w/2, 0]) cube(size=[l, w, d]);
            translate([0,0,d-bd]) ToothProfileX(l, bw);
            for ( xo = [-(l1/2+l2)-l3, (l1/2+l2)] )
                {
                    translate([xo, -bw/2, -d/2])
                    {
                        cube(size=[l3,bw,d*2]);
                    }
                }
            for ( xo = [-hpx/2, hpx/2])
            {
                for ( yo = [-hpy/2, hpy/2] )
                {
                    translate([xo, yo, -d/2])
                        cylinder(r=hd/2, h=d*2, $fn=8) ;
            //        translate([xo, yo, nt])
            //            mirror([0,0,1])
            //                nutrecessZ(naf, d*3, 3, d*2);
                }
            }
        }
        translate([-l1/2-l2,-w/2, 0])
            cube(size=[l1+l2+l2, w, d]) ;
        for ( xo =[-l1/2-l2, l1/2] )
            translate([xo,-w/2+2,0])
                cube(size=[l2, w-4, d+l2]) ;
    }
}

// Belt connector clamping piece
//
// l   = overall length
// w   = overall width
// d   = overall thickness (depth)
// hpy = hole pitch Y
// hd  = hole diameter (countersink width twice this)
// nt  = nut thickness
//
module BeltConnectorClamp(l, w, d, hpy, hd, naf, nt)
{
    difference()
    {
        translate([-l/2, -w/2, 0]) cube(size=[l, w-1.5, d]);
        for ( yo = [-hpy/2, hpy/2] )
        {
            //translate([0, yo, d]) 
            //    countersinkZ(6, d*3, 3, d*2);
            for ( yo = [-hpy/2, hpy/2] )
                translate([0, yo, nt]) 
                    nutrecessZ(naf, d*3, 3, d*2);
        }
    }
}

BeltConnectorBase(40, 20, 5,   10, 2, 7,   6, 2.5,   33, 12, 3,   5.5, 2);

for ( xo = [ -20, 20 ] )
{
    translate([xo, -30, 0]) 
        BeltConnectorClamp(7, 20, 4,  12, 3, 5.5, 2);
} 
