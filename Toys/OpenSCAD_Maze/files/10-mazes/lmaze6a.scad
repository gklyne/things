
/**
 *	A maze-box based off Sneakypoo's fantastic Labyrinth Gift Box at
 *	http://www.thingiverse.com/thing:201097
 *
 * A little editing in blender made a 'key blank' that I could
 *	subtract from in openscad, and a bunch more programming
 *	let it take a maze described in an array.
 *
 * So instead of making a maze with a lot of tedious hand-editing
 * of 3d objects, you can make a maze with a lot of tedious
 *	hand-editing of openscad data :D
 */

rows=20;	
sectors=32; 	// How many sectors do we divide a circle into

bolt_r=30.75/2;	// radius of the unchiselled bolt
cap_h=15;	// Thickness of the 'cap' on the end
wall=2.5;	// thickness of vertical walls between maze channels
depth=2;		// how deep to cut into the bolt
w1=1;			// The narrow bottom of the channels
w2=5;			// The wider tops
//aoff=-33;	// Adjust this to line the maze up with the hexagon

arcw=360/(sectors);		// How many degrees per sector
aslop=18;// Bevelled edges mean we need them extra-wide for the channels to match
va=18;
nubd=2;	// Diameter of the locking nub

aoff=(360/sectors)*(6+6);
// Maze generator which takes ASCII art
// It takes 14x8 mazes, which amount to
// 32 x 20 ASCII art.
m=[
  /* 0 1 2 3 4 5 6 7 8 9 a b c d e */
	"############### ################",
   "#   #       #     #   #     # # ",
	"### # ##### # # # ### # ### # # ",
	"#   #     #   # #   #   # # # # ",
	"# # ##### # ### ### # ### ### # ",
	"# #       # #     #   # #     # ",
	"# ######### ##### # ### ### ### ",
	"#   # #   #   #   ###   #     # ",
	"### # # # ### ####### ### ##### ",
	"  #     # # #   #   #   # #      ",
	"# ##### # # # # # # # # # ### ##",
	"#         # # #   # # #     # # ",
	"# ####### # # ##### # ##### #   ",
	"#   #     # #   # # # #   # # # ",
	"### # ##### ### # # # # # # # ##",
	"#   #         # #   # # # #    #",
	"# ### ######### ##### ### ### ##",
	"  # # #     #   #   #     #   #  ",
	"# # # # ### # ### ####### # ### ",
	"#   #   #   #   #         #   # ",
//	"################################",
];




aoff_old=(360/sectors)*6;
m_old=[
	"################### ############",
	"# ###   # #   #       #   #   # ", 
	"# ### ### # ### # ### ### # # # ",
	"#             # #   #     # # # ",
	"##### ########### ### ### # # # ",
	"###     #   # # #   #     #     ",
	"# ####### ### # # ### # # ### ##",
	"#   #   #   # #   # # # # # # ##",
	"# ######### # ### # ### ### ####",
	"  #   ###   #     #       # #    ", // connects around to left side
	"# ### ### ##### ####### ### # # ",
	"# # # ### #   # #   #   #   # # ",
	"# # # ##### ##### ##### # ### ##",
	"#   #     #         #       # # ",
	"# ######### ####### ### ### # # ",
	"      ###   #     # # # ### # #  ", // Connects around to other side
	"# ########### # # ### # ##### # ",
	"#             # #   #     ### # ",
	"# ### # ### ####### # # ##### ##",
	"    # # #     #       #   #    #",
//	"################################",
];

function xlen2(row, x)=(row[x]==" ")?1+xlen2(row,x+1) : 0;
function xlen(row,x)=	(
			(row[x] != " ")
			|| (x >= (len(row)-1))
			|| (( x < (len(row)-1)) && (row[x+1] != " "))
			|| ((x>0) && (row[x-1]==" "))
	) ? 0 : xlen2(row,x);

function ylen2(m, x, y)=(m[y][x]==" ")?1+ylen2(m,x,y+1) : 0;
function ylen(m, x, y)=(
			(m[y][x] != " ")
			|| (y >= (len(m)-1))
			|| (( y < (len(m)-1)) && (m[y+1][x] != " "))
			|| ((y>0) && (m[y-1][x]==" "))
	) ? 0 : ylen2(m,x,y);



// An ungraceful but functional way to make a pie-section.
module pie(r=10, f=270, s=0, h=1) {
	d=f-s;
	intersection() {
//	cylinder(r=r, h=h);
	translate([0,0,-1]) linear_extrude(h+2)	polygon([
			[0,0],
			[2*r*sin(s+d*(0/4)), 2*r*cos(s+d*(0/4))],
			[2*r*sin(s+d*(1/4)), 2*r*cos(s+d*(1/4))],
			[2*r*sin(s+d*(2/4)), 2*r*cos(s+d*(2/4))],
			[2*r*sin(s+d*(3/4)), 2*r*cos(s+d*(3/4))],
			[2*r*sin(s+d*(4/4)), 2*r*cos(s+d*(4/4))],
		]);
	}
}

module trapz(r1=bolt_r-depth, r2=bolt_r, h1=w1, h2=w2, off=bolt_r-depth) assign(d=(r2-r1)) {
			translate([off,0]) polygon(points=[	[0, -h1/2],
							[0, h1/2],
							[d, h2/2],
							[d, -h2/2] ]);
}

/**
 *	Spinning a trapezoid in cross-section to get a less-square
 *	channel shape.
 */
module owedge(r1=bolt_r-depth, r2=bolt_r, h1=w1, h2=w2)
	assign(off=h2-h1) {
		translate([0,0,h2/2]) rotate_extrude() trapz();
//			polygon(points=[	[r1, -h1/2],
//							[r1, h1/2],
//							[r2, h2/2],
//							[r2, -h2/2] ]);
}


/**
 *	The little nub at the bottom to make the bolt 'snap' shut
 *	on the case.
 */
rotate(-[0,0,arcw]/3) translate([0,bolt_r-depth,wall]) sphere(nubd/2);

//lt_h=100;

module polar(x,y, off=bolt_r) {
	rotate([0,0,arcw]*x) translate([off,0,(y*bolt_h)/(rows+1)]) children();
}

bolt_h=88-10;

module beam(l=1) translate([0,0,w2]/2) rotate([-90,0,0]) intersection() {
	linear_extrude(w2, center=true) hull() {
		trapz(off=0);
		translate([0,0.95*(l*bolt_h)/rows]) trapz(off=0);
	}
	rotate([90,180,180]) translate([0,0,-5]) linear_extrude(10+((l*bolt_h)/rows)) trapz(off=0);
}

module wedge(l, xtra=10) difference() {
	intersection() {
		owedge();
		rotate([0,0,270]) pie(bolt_r+10, xtra, -xtra-arcw*l, 6);
	}

	rotate([180,0,5-xtra/2]) translate([-.1+bolt_r-depth, 0, -7]) rotate([0,0,30]) cube([10,10,10]);
	rotate([0,0,-5+(arcw*l)+xtra/2])	translate([-.1+bolt_r-depth, 0, -3]) rotate([0,0,30]) cube([10,10,10]);
}

//wedge(10, 10);
//translate(-[2,2]) wedge(10, 0);

difference() {

//	translate([0,0,-4]) cylinder(r=bolt_r-.5, h=bolt_h+2);
	translate(-[.25,0,cap_h+wall]) import("blank.stl");

	rotate([0,0,aoff]) union() {

		// Row 0 needs to be longer.
		for(y=[0:0]) for(x=[0:sectors-1]) assign(h=ylen(m,x,y)-1) if(h > 0)
			polar(x,3+rows-y-1,off=bolt_r-depth) beam(h+3);
	
		for(y=[1:rows-1])	for(x=[0:sectors-1]) assign(h=ylen(m,x,y)-1) if(h>0)
			polar(x,rows-y-1,off=bolt_r-depth) beam(h);		

		for(y=[0:rows-1])
		for(x=[0:sectors-1])
			if(xlen(m[rows-y-1], x)) polar(x,y,off=0) wedge(xlen(m[rows-y-1],x)-1);
	}

}
