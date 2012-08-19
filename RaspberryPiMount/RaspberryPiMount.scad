// Rasperry Pi mounting bracket

rpil = 86;        // RPi board length +1
rpiw = 56;        // RPi board width
rpit = 1.5;       // RPi board thinkness
rpim = 1.25;      // RPi margin on PCB sides (except where HDMI port)
// For the following, corner with power connector is (0,0)
// with length along X-axis, and width along Y-axis.
// x=0 edge:
powerymin = 3.5;  // Min-Y of micro-USP power connector (no clearance)
powerymax = 11.5; // Max-Y of micro-USP power connector (no clearance)
powerht   = -0.8;  // Height (from base of board)
cardymin  = 14.5; // Min-Y of SD card holder
cardymax  = 44.5; // Max-Y ..
cardht    = -3.5; // Height (*below* base of board, with clearance)
// y=0 edge
hdmixmin = 37;    // Min-X of HDMI socket (no clearance)
hdmixmax = 52;    // Max-X of HDMI socket (no clearance)
hdmiht   = 7.6;   // Height (from base of board)
// x=max edge
netminy  = 2;     // Min-Y of Network socket
netmaxy  = 18;    // Max-Y ..
netht    = 15;    // Height (from base of board)
usbminy  = 24.5;  // Min-Y of USB socket
usbmaxy  = 37.7;  // Max-Y ..
usbht    = 17.5;  // Height (from base of board)
// y=max edge
videox   = 46;    // Y-offset to centre of video connector
videoh   = 9;     // H-offset (from base of board)
videod   = 8.25;  // Diameter of video connector ** allow for plug **
audiox   = 64.6;  // Y-offset to centre of audio connector
audioh   = 7.75;  // H-offset (from base of board)
audiod   = 7;     // Diameter of audeo connector

module box(l, w, h, t)
{
  t2 = t * 2;
  difference()
  {
    cube( size=[l,w,h] );
    translate([t,t,t])
      cube( size=[l-t2, w-t2, h-t]) ;
  }
}

module boxsides(l, w, h, t)
{
  t2 = t * 2;
  difference()
  {
    cube( size=[l,w,h] );
    translate([t,t,0])
      cube( size=[l-t2, w-t2, h]) ;
  }
}

// len, width, height overall (internal)
// Wall thickness
// Support shoulder thickness
// Support height
module frame(lo, wo, ho, tw, ts, hs)
{
  difference()
  {
    boxsides(lo+tw*2, wo+tw*2, ho, tw+ts);
    translate([tw,tw,hs])
      cube(size=[lo,wo,ho]);
  }
}

// Mounting tab
module tab(l,w,t,cornerrad,holedia,xo,yo)
{
  rc = ((xo==0) && (yo==0)) ?  0 :
       ((xo==1) && (yo==0)) ?  1 :
       ((xo==1) && (yo==1)) ?  2 : 3;
  rotate([0,0,rc*90])
  {
    difference()
    {
      union()
      {
        translate([0,0,0]) cube(size=[l-cornerrad, w, t]);
        translate([0,0,0]) cube(size=[l, w-cornerrad, t]);
        translate ([l-cornerrad,w-cornerrad,0])
          cylinder(r=cornerrad, h=t, $fn=16);
      }
      translate([l-cornerrad, w-cornerrad, -t/2])
        cylinder(r=holedia/2, h=t*2, $fn=12);
    }
  }
}

// Cutout in frame side
module cutout(minx, maxx, miny, maxy, baseh, h)
{
  clearance = 0.5;
  cutheight = abs(h)+20;
  echo("Cutout x=",[minx,maxx]," y=",[miny,maxy],"h=",h," clearance=",clearance);
  if ( h > 0 )
  {
    translate([minx-clearance,miny-clearance,baseh])
      cube(size=[maxx-minx+2*clearance, maxy-miny+2*clearance, cutheight]);
  }
  else
  {
    translate([minx-clearance,miny-clearance,baseh+h-clearance])
      cube(size=[maxx-minx+2*clearance, maxy-miny+2*clearance, cutheight]);    
  }
}

// Hole cutout Y-aligned in frame side
module cutoutholeY(x, miny, maxy, h, d)
{
  clearance = 0.5;
  translate([x,miny-clearance,h])
    rotate([-90,0,0])    // (rotate from +Z to +Y axis)
      # cylinder(r=d/2+clearance,h=maxy-miny+clearance*2,$fn=16);
}

// Board retaining ridge
// min-x, max-x, y-pos of centre, height of centre, depth
module ridgeX(xmin, xmax, y, h, d)
{
  d2 = d*sqrt(2);
  translate([xmin,y,h])
    rotate([45,0,0])
      translate([0,0,0])
        # cube(size=[xmax-xmin,d2,d2]);
}

frameth  = 2.5;   // Thickness of outer frame
boardht  = 7;     // Height to board
totalht  = 15;    // Height overall
tabln    = 10;    // Length of corner tab
tabwd    = 10;    // Width of corner tab
tabth    = 2;     // Thickness of corner tab
holedia  = 4;     // Diamater screw hole in tab

module rpimount()
{
  clearance = 0.5;
  lenov = rpil+frameth*2+clearance;    // Overall length
  widov = rpiw+frameth*2+clearance;    // Overall width
  supth = frameth+rpim;                // Thickness of support frame
  tablo = tabln+supth;                 // Screw tab length overall
  tabwo = tabwd+supth;                 // Screw tab width overall
  difference()
  {
    union()
    {
      frame(rpil+clearance,rpiw+clearance,totalht,frameth,rpim,boardht);
      // Add mounting tabs
      for (xo = [0,1])
      {
        for (yo = [0,1])
        {
        translate ([xo*lenov,yo*widov,0])
          tab(tablo, tabwo, tabth, (min(tablo,tabwo)-supth)/2, holedia, xo, yo);
        }
      }
      // Add retaining ridges
      ridgeX(0, 12,                frameth,       boardht+rpit, 1.25);
      ridgeX(lenov-12, lenov,      frameth,       boardht+rpit, 1.25);
      ridgeX(lenov/2-5, lenov/2+5, widov-frameth, boardht+rpit, 1.25);
    }
    // Cutout for power connector (extended to avoid silly stick-up post)
    cutout(0,supth,frameth+powerymin-1.5,frameth+powerymax+10,boardht,powerht);
    // Cutout for SD card
    cutout(0,supth,frameth+cardymin,frameth+cardymax,boardht,cardht);
    // Cutout for HDMI
    cutout(frameth+hdmixmin,frameth+hdmixmax,0,supth,boardht,hdmiht);
    // Cutout for Ethernet (extended to avoid silly sick=up post)
    cutout(lenov-supth,lenov,frameth+netminy,frameth+netmaxy+10,boardht,netht);
    // Cutout for USB
    cutout(lenov-supth,lenov,frameth+usbminy,frameth+usbmaxy,boardht,usbht);
    // Cutout for audio
    cutoutholeY(audiox+frameth,widov-supth,widov,boardht+audioh,audiod);
    // Cutout for video
    cutoutholeY(videox+frameth,widov-supth,widov,boardht+videoh,videod);
  }
}

rpimount();

//tab(10, 20, 2, 3, 4);

//ridgeX(0,10,0,2,2);
