// Parameters file for RepRap Huxley (and maybe Mendel)

// Set ONE OF these true.

huxley=false;
mendel=!huxley;



pi=3.14159265;

// The relative location in your file system where the .dxf files are
// DXFs are for quick development.  They should be replaced by parameterised CSG in dure course.

fileroot="DXF-files/";

rodsize = 6;	//threaded/smooth rod diameter in mm
xaxis = 182.5;	//width of base in mm
yaxis = 266.5;	//length of base in mm


screwsize = 3;	//bearing bore/screw diameter in mm
bearingsize = 10;	//outer diameter of bearings in mm
bearingwidth = 4;	//width of bearings in mm


rodpitch = rodsize / 6;
rodnutsize = 0.8 * rodsize;
rodnutdiameter = 1.9 * rodsize;
rodwashersize = 0.2 * rodsize;
rodwasherdiameter = 2 * rodsize;
screwpitch = screwsize / 6;
nutsize = 0.8 * screwsize;
nutdiameter = 1.9 * screwsize;
pentanutradius=1.04*screwsize;
washersize = 0.2 * screwsize;
washerdiameter = 2 * screwsize;
partthick = 2 * rodsize;
vertexrodspace = 2 * rodsize;


c = [0.3, 0.3, 0.3];
rodendoffset = rodnutsize + rodwashersize * 2 + partthick / 2;
vertexoffset = vertexrodspace + rodendoffset;


renderrodthreads = false;
renderscrewthreads = false;
fn = 36;

// The gap between the joining rods at a vertex

vertex_radius=sqrt(rodsize*rodsize + vertexoffset*vertexoffset);
vertex_ang = atan(vertexoffset/rodsize)-30;
vertex_gap = 2*vertex_radius*cos(vertex_ang);

// Nema 17 dimensions - these are absolute

nema17_square=42;
nema17_screws=31;
nema17_screw_r=1.5;
nema17_hub=22;
nema17_hub_depth=2;
nema17_length=36;
nema17_shaft=5;
nema17_shaft_length=55;
nema17_shaft_projection=22;

// Nema 14 dimensions - these are absolute

nema14_square=35.3;
nema14_screws=26;
nema14_screw_r=1.5;
nema14_hub=22;
nema14_hub_depth=2;
nema14_length=36;
nema14_shaft=5;
nema14_shaft_length=66;
nema14_shaft_projection=19;

// Nema 11 dimensions - these are absolute

nema11_square=28.5;
nema11_screws=23;
nema11_screw_r=1.25;
nema11_hub=22;
nema11_hub_depth=2;
nema11_length=44.5;
nema11_shaft=5;
nema11_shaft_length=78;
nema11_shaft_projection=18;

// Limit switch parameters

limit_switch_hole_diameter=2.5;
limit_switch_centres=9.5;

// The RepRap slide bearings

bearing_mount_centres=18;
bearing_width=7;
bearing_depth=18;

// X axis parameters - many should be relative

x_bar_gap=30;
motor_center_y = 26;
bar_clamp_x=5;
bar_clamp_y=8;
bar_clamp_x_gap=23;
bearing_y=50;
bearing_x=bar_clamp_x_gap + 10;
hole_land=4;
thickness=5;
bearing_low_z = 8;
bearing_z_gap = 25;
bearing_plate_width = bearing_mount_centres+2*hole_land + 10;
bearing_plate_overlap=0.5;
bearing_plate_support=10;

