/*
 Ambiguous Cylinder Generator v1.4
 
 OpenSCAD Script by M. Hagedorn 
 www.thingiverse.com/drjames/

 Changes:
 v1.4 Presets included
 v1.3 Improved support structure removal by additional boolean operation
 v1.2 Initial Thingiverse Release

 Based on:
 Finalist of the Best Illusion of the Year Contest 2016

 Title: Ambiguous Cylinder Illusion
 Author: Kokichi Sugihara
 Institution: Meiji University, Japan
 
 See:
 www.youtube.com/watch?v=oWfFco7K9v8
*/

/* [Presets] */
// Pick a preset (Some parameters are ignored if you pick something other than "no"!)
Preset=0; // [0:No,1:Default 2 by 2,2:3 by 2]

/* [Size] */
// Height
mHeight=30; // [1:100]

// Diameter
mDiameter=18; // [1:100]

// Wall Thickness
WallThickness=1.5; // [0.25:0.25:10]

/* [ Illusion tweaks ] */
// Z-Rotation
mRotation=45; // [0:5:90]
// SuperEllipse Power (1=Square ... 2=Circle)
SuperEllipsePower=1.5; // [1:0.1:2]
// Sine Cutout Height (Adjust for Desired Viewing Angle)
SineCutoutHeight=1.5; // [0:0.1:3]

/* [Bottom and Support] */
// Flat Bottom
FlatBottom="no"; // [yes,no]
// Generate Base Support
GenerateBaseSupport="yes"; // [yes,no]
// Base Support: Gap Distance (mm)
SupportDistance=0.3; // [0:0.05:1]
// Base Support: Additional Height (mm)
SupportHeight=5; // [1:0.2:5]

/* [Array] */
// Count (X)
mXCount=1; // [1:10]
// Distance (X)
mXDistance=15; // [1:50]
// Count (Y)
mYCount=1; // [1:10]
// Distance (Y)
mYDistance=15; // [1:50]

Height  = Preset==1 ? 30: Preset==2 ? 30 : mHeight;
Diameter= Preset==1 ? 18: Preset==2 ? 18 : mDiameter;
Rotation= Preset==1 ? 45: Preset==2 ? 0  : mRotation;
XCount=   Preset==1 ? 2 : Preset==2 ? 2  : mXCount;
YCount=   Preset==1 ? 2 : Preset==2 ? 3  : mYCount;
XDistance=Preset==1 ? 24: Preset==2 ? 35 : mXDistance;
YDistance=Preset==1 ? 24: Preset==2 ? 35 : mYDistance;

for (x = [0:XDistance:XDistance*(XCount-1)], 
     y = [0:YDistance:YDistance*(YCount-1)]){
    translate([x,y,(FlatBottom=="yes"||GenerateBaseSupport=="no"?0:SupportHeight+SupportDistance)])
    rotate([0,0,Rotation])
    {
        // Top & Bottom Cut AmbiCylinder
        AmbiCylinder(Diameter,Height,WallThickness,cutBottom=(FlatBottom=="no"?true:false));
    }
}

if((FlatBottom=="no") && (GenerateBaseSupport=="yes"))
{
    difference() {
        
        // Base
        for (x = [0:XDistance:XDistance*(XCount-1)], 
             y = [0:YDistance:YDistance*(YCount-1)]){
            translate([x,y,(FlatBottom=="yes"||GenerateBaseSupport=="no"?0:SupportHeight+SupportDistance)])
            rotate([0,0,Rotation])
            {
                translate([0,0,-SupportDistance-SupportHeight])
                     AmbiCylinder(Diameter,(2*SineCutoutHeight)+SupportHeight,WallThickness,cutBottom=false);
            }
        }
        
        // v1.3: Cut away intersecting geometry so that supports can be removed easily
        for (x = [0:XDistance:XDistance*(XCount-1)], 
             y = [0:YDistance:YDistance*(YCount-1)]){
            translate([x,y,(FlatBottom=="yes"||GenerateBaseSupport=="no"?0:SupportHeight+SupportDistance)])
            rotate([0,0,Rotation])
            {
                translate([0,0,-SupportDistance])
                    AmbiCylinder(Diameter+WallThickness/2,Height,WallThickness*2,cutBottom=true);
            }
        }
    
    }
}


// superellipse function
//   by Chris (Kit) Wallace 
//   http://kitwallace.co.uk/Blog/item/2013-02-14T00:10:00Z
module superellipse(R, p, e=1 , n=96) {
    function x(R,p,e,a) =  R * pow(abs(cos(a)),2/p) * sign(cos(a));
    function y(R,p,e,a) =  R *e * pow(abs(sin(a)),2/p) * sign(sin(a));
      dth = 360/n;
        for ( i = [0:n-1] ) 
          polygon( 
                  [
                      [0,0], 
                      [x(R,p,e,dth*i), y(R,p,e,dth*i)], 
                      [x(R,p,e,dth*(i+1)),  y(R,p,e,dth*(i+1))]
                  ] );
}

// creates a polygon rectangle with sinus cutout
module SineCut(w,h,d=2,R=360,n=32) {
    points = [ 
      for (a = [0 : R/n : R]) 
          2 * [ (w/R/2)*a, sin(a)*h/2 ] 
    ];
      
    translate([0,-h,0])
        polygon(concat(points, [[0, 0],[w, sin(R)*h],[w,h+d],[0,h+d]] ));
}

// create one ambiguous cylinder
module AmbiCylinder(cD,cH,cW=1,p=SuperEllipsePower,h=SineCutoutHeight,cutBottom=false) {
        difference() {
            difference() {
                linear_extrude(cH) 
                    superellipse(cD*0.99,p);  // scale by 0.99 to avoid non-manifold csg
                translate([0,0,-0.01])        // move slightly so that quick preview is displayed correctly
                linear_extrude(cH*1.01)       // scale slightly to make quick preview display correctly
                    superellipse(cD*0.99-cW,p);
            }
            
            translate([-cD,cD,cH])
                rotate([90,0,0])
                    linear_extrude(cD*2)
                        SineCut(cD*2,h);
            
            if (cutBottom) {
                rotate([0,0,180])
                translate([-cD,cD,0])
                    rotate([90,0,0])
                        linear_extrude(cD*2)
                            SineCut(cD*2,-h,d=-1);
            }
            
         }              

}
