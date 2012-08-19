//linear_extrude(height=20, twist=0)
//{
//  difference()
//  {
//    polygon([[0,0],[0,10],[15,15],[10,0]]);
//    circle(r=5);
//  }
//}


w = 45;      // Width top of handrail
d = 25;      // Depth of heandrail.
h = 80;      // Height of main hanger
a = 16;      // Angle between handrail top and side
t1 = 20;     // Thickness at top of hanger
t2 = 14;     // Thickness at bottom of hanger
t3 = 4;      // Thickness of outer frame
t4 = 2.5;    // Thickness of frame web
r1 = 10;     // Outer radius of rope eye
r2 = 5;      // Radius of rope eye hole

p1  = [0,0];
p2  = [w,0];
p3  = [w,-d];
p4  = [w+t1,-d+t1];
p5  = [w+t1,0];
p6  = [w,t1];
p7  = [0,t1];
p8  = [-t1*cos(a),t1*sin(a)];
p9  = [-h*tan(a)-t2,-h];
p10 = [-h*tan(a),-h];
p11 = p10 + [-(r1+r1)*tan(a),-(r1+r1)];
p12 = p11 + [r1,0];

p21 = p1 + [-t3*cos(a),t3*sin(a)];
p22 = p8 + [t3*cos(a),-t3*sin(a)];
p23 = p9 + [t3*cos(a)+(t3+0.5*r1)*sin(a),t3+0.5*r1];
p24 = p10 + [-t3*cos(a)+(t3+0.35*r1)*sin(a),t3+0.35*r1];

p31 = p1 + [t3*(sin(a)-cos(a)),t3];
p32 = p8 + [t3*(cos(a)+sin(a)),t3*(cos(a)-sin(a))];
p33 = p7 + [-t3,-t3];

p41 = p1 + [0,t3];
p42 = p2 + [0,t3];
p43 = p6 + [0,-t3];
p44 = p7 + [0,-t3];

p51 = p2 + [t3,t3];
p52 = p5 + [-t3,t3];
p53 = p6 + [t3,-t3];

p61 = p2 + [t3,0];
p62 = p3 + [t3,t3];
p63 = p4 + [-t3,-t3];
p64 = p5 + [-t3,0];

module HangerProfile()
{
  difference()
  {
  union()
    {
      polygon([p1,p2,p3,p4,p5,p6,p7,p8,p9,p10]);
      circle(r=t1);
      translate(p2) circle(r=t1);
      translate([w,-d+t1]) circle(r=t1);
      translate(p10-[r1,0]) circle(r=r1);
    }
    polygon([p1,p2,p3,p12,p11]);
    translate(p10-[r1,0]) circle(r=r2);
  }
}

module WebProfile()
{
  polygon([p21,p22,p23,p24]);
  polygon([p31,p32,p33]);
  polygon([p41,p42,p43,p44]);
  polygon([p51,p52,p53]);
  polygon([p61,p62,p63,p64]);
}

  //polygon([[0,0],[w,0],[w,-d],
  //         [w+t1,-d+t1],[w+t1,0],[w,t1],
  //         [0,t1],[-t1*cos(a),t1*sin(a)],
  //         [-h*tan(a)-t2,-h],[-h*tan(a),-h]
  //         ], 
  //        convexity=4);


//difference()
//{
//  HangerProfile();
//  WebProfile();
//}


difference()
{
  linear_extrude(height=20, twist=0)
  {
    HangerProfile();
  }
  translate([0,0,t4])
    linear_extrude(height=20, twist=0)
      WebProfile();
}

