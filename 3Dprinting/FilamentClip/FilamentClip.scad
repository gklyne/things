// Filament clip

ol = 32;     // Overall length
ow = 9;     // Overall width
oh = 4;      // Overall height
cr = 3;      // Corner radius
d1 = 3.25;   // Diameter of filament
d2 = 2.8;    // Diameter of clip entry
d3 = 20;     // Diameter of finger grip
d4 = 11;     // Diamater of finger grip hole

module RoundedRectPlate(l, w, h, r)
{
    translate([0,0,h/2])
    {
        cube(size=[l,w-2*r,h], center=true);
        cube(size=[l-2*r,w,h], center=true);
    }
    for (dx = [-(l/2-r),(l/2-r)])
    {
        for (dy = [-(w/2-r),(w/2-r)])
        {
            translate([dx,dy,0]) cylinder(r=r, h=h);
        }
    }
}

module CutoutHole(x,y,r,h)
{
    delta = 0.5;
    translate([x,y,-delta]) cylinder(r=r,h=h+2*delta,$fs=0.5);
}

module CutoutCube(x,y,dx,dy,h)
{
    delta = 0.5;
    translate([x,y,h/2]) cube(size=[dx,dy,h+2*delta], center=true);
}

module CutoutSlot(x,y,dx,dy,h)
{
    delta = 0.5;
    translate([x,y,h/2])   cube(size=[dx,dy,h+2*delta], center=true);
    translate([x-dx/2,y,-delta]) cylinder(r=dy/2,h=h+2*delta,$fs=0.5);
    translate([x+dx/2,y,-delta]) cylinder(r=dy/2,h=h+2*delta,$fs=0.5);
}

// dir: 0: +x
//      1: +y
//      2: -x
//      3: -y
module FilamentJaw(pos,dir,fd,fe,h)
{
    translate(pos)
    {
        rotate([0,0,dir*90])
        {
            CutoutHole(-fd*0.8, 0, fd/2, h);
            CutoutHole(    0  , 0, fe/2, h);
            CutoutSlot(-fd*1.7, 0, fd, fe/2, h);
        }
    }
}

module FilamentClip()
{
    difference()
    {
        union()
        {
            RoundedRectPlate(ol, ow, oh, cr );
            translate([0,ow/2,0]) cylinder(r=d3/2, h=oh);
        }
        CutoutHole(0, ow/2, d4/2, oh);
        FilamentJaw([ ol/2,0,0], 0, d1, d2, oh);
        FilamentJaw([-ol/2,0,0], 2, d1, d2, oh);
        //FilamentJaw([ ol/4,-ow/2,0],3,d1,d2,oh);
        //FilamentJaw([-ol/4,-ow/2,0],3,d1,d2,oh);
    }
}

yd = ow+d3/2;
for (yo = [-yd,yd])
{
    translate([0,yo,0]) FilamentClip();
}
