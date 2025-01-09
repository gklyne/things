//digits are made of 3x5 'boxels'. specify boxel size (mm)
boxel_size=8;
//elements height (mm)
elem_height=5;
//Display solved puzzle
solved=0;
//render box
box=1;
//box_thickness (mm)
box_thickness=2;
//extra space in box to ease insertion (mm)
space=1;
//ease in the dented boxels. keep this very small (~0.05)
jeu=0.05;
//box height (mm)
box_height=2;
//render colors (0 fot no / 1 for yes)
colored=0;
boxel=[
	[],							//empty
	[[-0.5,-0.5],[0.5,-0.5],[0.5,0.5],[-0.5,0.5]],		//full
	[[-0.5,-0.5],[0.5,-0.5],[0.5,0.5]],			//half (diagonal)
	[[-0.5+jeu,-0.5],[0.5-jeu,-0.5],[0,-jeu]],				//pointy dent
	[[-0.5,-0.5+jeu],[-0.5,0.5],[0.5,0.5],[0.5,-0.5+jeu],[0,jeu]]	//full dented
];

//digits definitions. 5 x 3 pairs, each pair is [boxel index , Z rotate x 90°]
digit=[
[  //0
 [[2,0],[1,0],[2,3]],
 [[1,0],[0,0],[1,1]],
 [[3,0],[0,0],[4,3]],
 [[1,0],[0,0],[1,0]],
 [[2,1],[1,0],[2,2]]
],
[ //1
[[3,0],[0,0],[0,0]],
[[1,0],[0,0],[0,0]],
[[4,3],[0,0],[0,0]],
[[1,0],[0,0],[0,0]],
[[3,2],[0,0],[0,0]]
],
[ //2
 [[3,1],[1,0],[2,3]],
 [[0,0],[0,0],[1,0]],
 [[2,0],[1,0],[2,2]],
 [[1,0],[0,0],[0,0]],
 [[2,1],[1,0],[3,3]]
],
[ //3
 [[3,1],[1,0],[2,3]],
 [[0,0],[0,0],[1,0]],
 [[3,1],[1,0],[4,1]],
 [[0,0],[0,0],[1,0]],
 [[3,1],[1,0],[2,2]]
],
[ //4
 [[3,0],[0,0],[3,0]],
 [[1,0],[0,0],[1,0]],
 [[2,1],[1,0],[4,1]],
 [[0,0],[0,0],[1,0]],
 [[0,0],[0,0],[3,2]]
],
[ //5
 [[2,0],[1,0],[3,3]],
 [[1,0],[0,0],[0,0]],
 [[2,1],[1,0],[2,3]],
 [[0,0],[0,0],[1,0]],
 [[3,1],[1,0],[2,2]]
],
[ //6
 [[2,0],[1,0],[3,3]],
 [[1,0],[0,0],[0,0]],
 [[4,3],[1,0],[2,3]],
 [[1,0],[0,0],[1,0]],
 [[2,1],[1,0],[2,2]]
],
[ //7
 [[3,1],[1,0],[2,3]],
 [[0,0],[0,0],[1,1]],
 [[0,0],[0,0],[4,3]],
 [[0,0],[0,0],[1,0]],
 [[0,0],[0,0],[3,2]]
],
[ //8
 [[2,0],[1,0],[2,3]],
 [[1,0],[0,0],[1,0]],
 [[4,3],[1,0],[4,1]],
 [[1,0],[0,0],[1,0]],
 [[2,1],[1,0],[2,2]]
],
[ //9
 [[2,0],[1,0],[2,3]],
 [[1,0],[0,0],[1,0]],
 [[2,1],[1,0],[4,1]],
 [[0,0],[0,0],[1,0]],
 [[3,1],[1,0],[2,2]]
]
];



//Rotate to solve
rsolved=[
	[  0	,  0	,  0	],	//  0
	[  0	,  0	,-90	], 	//  1
	[  0	,180	,-90	],	//  2
	[  0	,  0	, 90	],	//  3
	[  0	,  0	, 90	],	//  4
	[  0	,  0	,  0	],	//  5
	[  0	,  0	,-90	],	//  6
	[  0	,  0	, 90	],	//  7
	[  0	,  0	,  0	],	//  8
	[  0	,  0	,-90	]	//  9
	];

//Translate to solve
tsolved=[
	[ 7	, 1	, 0	],	//  0
	[ 4	,-2	, 0	], 	//  1
	[ 0	, 2	, 0	],	//  2
	[ 6	, 6	, 0	],	//  3
	[ 2	, 6	, 0	],	//  4
	[ 3	, 3	, 0	],	//  5
	[ 6	, 4	, 0	],	//  6
	[ 6	, 0	, 0	],	//  7
	[-1	, 5	, 0	],	//  8
	[ 0	, 0	, 0	]	//  9
	];

//Rotate to print
rprint=[
	[  0	,0	,  0	],	//  0
	[  0	,0	,  0	],	//  1
	[  0	,0	,  0	],	//  2
	[  0	,0	,  0	],	//  3
	[  0	,0	,  0	],	//  4
	[  0	,0	, 90	],	//  5
	[  0	,0	,  0	],	//  6
	[  0	,0	, 90	],	//  7
	[  0	,0	,-45	],	//  8
	[  0	,0	,  0	],	//  9
	];

//Translate to print 
// (a bit messy, but minimizes footprint & travel time without showing the solution)
tprint=[
	[-3	, 6.0	,0	],	//  0
	[ 0.15	, 5.4	,0	],	//  1
	[ 1.3	, 5.9	,0	],  	//  2
	[ 3.45	, 5.9	,0	],  	//  3
	[-3	, 1.8	,0	],  	//  4
	[ 2.5	, 1.1	,0	],	//  5
	[-3.6	,-1.8	,0	],  	//  6
	[ 1.1	, 1.8	,0	],  	//  7
	[ 2.83	,-1.9	,0	],	//  8
	[-0.9	,-2.2	,0	]   	//  9
	];
	
dcolor=[[0.5,0.5,0],[0.5,0,0.5],[0,0.5,0.5],[1,0,0],[0,1,0],[0,0,1],[1,1,0],[0,1,1],[1,0,1],[0.5,1,0.8],];

//--------------------------------------------------------------
// render digit n° nd
//--------------------------------------------------------------
module mkdigit(nd) {
	for ( row = [0 : 4] )
		{
		for ( col = [0 : 2] )
			{
			translate([(col-1)*boxel_size,(2-row)*boxel_size,0])
			scale([boxel_size,boxel_size,1])
			rotate([0,0,digit[nd][row][col][1]*90])
					scale(1.001) //for manifold... avoids adjacent faces
					linear_extrude(height = elem_height, center = true, convexity = 10)
					polygon(points=boxel[digit[nd][row][col][0]]);
			}
		}
     
 };

//--------------------------------------------------------------
// render and place all digits
//--------------------------------------------------------------
 for (digitnum=[0:9])
 {
	color(colored*dcolor[digitnum]+(1-colored)*[0.5,0.8,1]) 
	union() {
	translate([0,0,elem_height/2]+(box*solved*[0,0,box_thickness]))
	translate((1-solved)*tprint[digitnum]*boxel_size) 
	translate(solved*boxel_size*(tsolved[digitnum]-[3,3,0]))
		rotate(solved*rsolved[digitnum])
		rotate((1-solved)*rprint[digitnum])
			mkdigit(digitnum);
	}
} 

//--------------------------------------------------------------
// render box
//--------------------------------------------------------------
scale(box)
translate((1-solved)*[boxel_size*9.5+box_thickness*2+space,boxel_size*2,0])
translate([0,0,(box_height+box_thickness)/2])
rotate((1-solved)*[0,0,90])
difference(){
	cube(size=[boxel_size*11+box_thickness*2+space,boxel_size*9+box_thickness*2+space,box_height+box_thickness],center=true);
	translate([0,0,box_thickness])cube(size=[boxel_size*11+space,boxel_size*9+space,box_height+box_thickness],center=true);
}