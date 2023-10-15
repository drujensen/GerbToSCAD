//    Aperture primitives are part of GerbToSCAD.rb
//    Copyright (C) 2013 Dru Jensen
//
//    GerbToSCAD is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    GerbToSCAD is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
$fn=20;

board_thickness = 2.0;    //Change to alter board thickness
stencil_thickness = 0.4;  //Change to alter gap thickness
hole_size = 1.6;          //Change to alter size of the hole
stand_height = 4.0;       //Change to alter the stand height

// Generate the Board
board();

// Generate the Stencil
// stencil();

//////////////////////////////////////////////////////////////////////////////////////////////////
// Start of aperture primitives: circle, rectangle, obround, polygon                    
// These accept the same parameters in the same order as Gerber aperture definitions    
// 'drill' holes in pads will be rendered if specified even though they are unprintable 
//////////////////////////////////////////////////////////////////////////////////////////////////

// Circle aperture type
module gerb_circle (diameter, hole_X=0, hole_Y=0) {
  if (hole_X == 0) {
    cylinder (r = diameter/2, h=stencil_thickness + .1, center = true);
  }
  else if (hole_Y == 0) {
    union(){
      cylinder (r = diameter/2, h=stencil_thickness + .1, center = true);
      translate([0,0,-board_thickness/2]) cylinder (r = hole_X/2, h=board_thickness + .1, center = true);
    }
  }
  else {
    union(){  
      cylinder (r = diameter/2, h=stencil_thickness + .1, center = true);
      translate([0,0,-board_thickness/2]) cube (size = [hole_X, hole_Y, board_thickness + .1], center = true);
    } 
  } 
}

// Rectangle aperture type
module gerb_rectangle (diam_X, diam_Y, hole_X=0, hole_Y=0) {
  if (hole_X==0) {
    cube (size = [diam_X, diam_Y, stencil_thickness + .1], center = true);
  }
  else if (hole_Y == 0) {
    union(){
      cube (size = [diam_X, diam_Y, stencil_thickness + .1], center = true);
      translate([0,0,-board_thickness/2]) cylinder (r = hole_X/2, h=board_thickness + .1, center = true);  
    }
  }
  else  {
    union(){
      cube (size = [diam_X, diam_Y, stencil_thickness + .1], center = true);
      translate([0,0,-board_thickness/2]) cube (size = [hole_X, hole_Y, board_thickness + .1], center = true);
    }
  }
}

// Obround aperture type
module gerb_obround_primitive (diam_X, diam_Y) {
  if (diam_X < diam_Y) {
    union(){
      cube(size = [diam_X, diam_Y-diam_X, stencil_thickness + .1], center = true);
      translate(v = [0, (diam_Y - diam_X) / 2, 0]) cylinder (r = diam_X/2, h=stencil_thickness, center = true);
      translate(v = [0, -((diam_Y - diam_X) / 2), 0]) cylinder (r = diam_X/2, h=stencil_thickness, center = true);
    }
    
  }
  else {  // diam_X is larger
    union(){
      cube(size = [diam_X-diam_Y, diam_Y, stencil_thickness + .1], center = true);
      translate(v = [(diam_X - diam_Y) / 2, 0, 0]) cylinder (r = diam_Y/2, h=stencil_thickness, center = true);
      translate(v = [-((diam_X - diam_Y) / 2), 0, 0]) cylinder (r = diam_Y/2, h=stencil_thickness, center = true);
    }
  }
}

module gerb_obround (diam_X, diam_Y, hole_X=0, hole_Y=0) {
  if (hole_X==0) {
    gerb_obround_primitive(diam_X, diam_Y);
  }
  else if (hole_Y == 0) {
    union(){
      gerb_obround_primitive(diam_X, diam_Y);
      translate([0,0,-board_thickness/2]) cylinder (r = hole_X/2, h=board_thickness + .1, center = true);  
    }
  }
  else  {
    union(){
      gerb_obround_primitive(diam_X, diam_Y);
      translate([0,0,-board_thickness/2]) cube (size = [hole_X, hole_Y, board_thickness + .1], center = true);
    }
  }
}

// Polygon aperture type
module gerb_polygon (diameter, num_sides, rotation=0, hole_X=0, hole_Y=0) {
  if (hole_X == 0) {
    rotate (a=[0,0,rotation]) cylinder (r = diameter/2, h=stencil_thickness + .1, $fn = num_sides, center = true);
  }
  else if (hole_Y == 0) {
    union(){
      rotate (a=[0,0,rotation]) cylinder (r = diameter/2, h=stencil_thickness + .1, $fn = num_sides, center = true);
      translate([0,0,-board_thickness/2]) cylinder (r = hole_X/2, h=board_thickness + .1, center = true);
    }
  }
  else {
    union(){  
      rotate (a=[0,0,rotation]) cylinder (r = diameter/2, h=stencil_thickness + .1, $fn = num_sides, center = true);
      translate([0,0,-board_thickness/2]) cube (size = [hole_X, hole_Y, board_thickness + .1], center = true);
    } 
  } 
}

// The main board

module block(x, y, z) {
  translate(v=[x/2, y/2,board_thickness/2]) cube (size = [x, y, board_thickness], center = true);
}

// A stand to allow us to hold the board so we can print the stencil at the
// correct height.

module stand (x, y, z) {
	translate ([x/2,y/2, -((z+stand_height)/2) ])  difference() {
		cube (size = [x+1.2, y+1.2, board_thickness+stand_height+stencil_thickness], center = true);
		cube (size = [x-1.2, y-1.2, board_thickness+stand_height+stencil_thickness+.1], center = true);
		translate([0,0, (stand_height+stencil_thickness)/2]) cube (size = [x+0.2, y+0.2, stencil_thickness], center = true);
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////
// End of aperture primitives -- everything below is generated from the input gerber    
//////////////////////////////////////////////////////////////////////////////////////////////////

// Start of aperture definitions

module D10_w_hole() {
  gerb_circle(1.9049999999999998, hole_size);
}
module D10() {
  gerb_circle(1.9049999999999998);
}
module D11_w_hole() {
  gerb_circle(2.0827999999999998, hole_size);
}
module D11() {
  gerb_circle(2.0827999999999998);
}
module D12_w_hole() {
  gerb_circle(1.7018, hole_size);
}
module D12() {
  gerb_circle(1.7018);
}
module D13_w_hole() {
  gerb_circle(1.3716, hole_size);
}
module D13() {
  gerb_circle(1.3716);
}
module D14_w_hole() {
  gerb_circle(3.556, hole_size);
}
module D14() {
  gerb_circle(3.556);
}
module D15_w_hole() {
  gerb_rectangle(1.9049999999999998, 1.9049999999999998, hole_size);
}
module D15() {
  gerb_rectangle(1.9049999999999998, 1.9049999999999998);
}
module D16_w_hole() {
  gerb_rectangle(2.0827999999999998, 2.0827999999999998, hole_size);
}
module D16() {
  gerb_rectangle(2.0827999999999998, 2.0827999999999998);
}
module D17_w_hole() {
  gerb_rectangle(1.7018, 1.7018, hole_size);
}
module D17() {
  gerb_rectangle(1.7018, 1.7018);
}
module D18_w_hole() {
  gerb_rectangle(1.3716, 1.3716, hole_size);
}
module D18() {
  gerb_rectangle(1.3716, 1.3716);
}
module D19_w_hole() {
  gerb_circle(0.8466582, hole_size);
}
module D19() {
  gerb_circle(0.8466582);
}
module board() {
  // scale the board 
  scale(v=[1.0,1.0,1.0]) difference(){

    // draw the solid part
    block (66.5988, 40.03039999999999, board_thickness);

    // subtract each aperture flash with holes
    translate (v=[14.808, 29.312, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[17.348, 29.312, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[14.910, 19.075, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[12.370, 19.075, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[12.370, 23.647, board_thickness - (stencil_thickness/2)]) D11_w_hole();
    translate (v=[14.910, 23.647, board_thickness - (stencil_thickness/2)]) D11_w_hole();
    translate (v=[17.450, 23.647, board_thickness - (stencil_thickness/2)]) D11_w_hole();
    translate (v=[29.642, 21.133, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[29.642, 28.753, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[32.182, 21.133, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[32.182, 28.753, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[34.722, 21.133, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[34.722, 28.753, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[37.262, 21.133, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[37.262, 28.753, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[39.802, 21.133, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[39.802, 28.753, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[42.342, 21.133, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[42.342, 28.753, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[44.882, 21.133, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[44.882, 28.753, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[47.422, 21.133, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[47.422, 28.753, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[49.962, 21.133, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[49.962, 28.753, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[52.502, 21.133, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[52.502, 28.753, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[55.042, 21.133, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[55.042, 28.753, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[57.582, 21.133, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[57.582, 28.753, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[60.122, 21.133, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[60.122, 28.753, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[62.662, 21.133, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[62.662, 28.753, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[26.365, 6.096, board_thickness - (stencil_thickness/2)]) D12_w_hole();
    translate (v=[26.365, 16.256, board_thickness - (stencil_thickness/2)]) D12_w_hole();
    translate (v=[26.391, 27.483, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[26.391, 20.980, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[21.895, 27.483, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[21.895, 20.980, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[55.220, 10.312, board_thickness - (stencil_thickness/2)]) D13_w_hole();
    translate (v=[55.220, 2.692, board_thickness - (stencil_thickness/2)]) D13_w_hole();
    translate (v=[50.140, 2.769, board_thickness - (stencil_thickness/2)]) D13_w_hole();
    translate (v=[50.140, 10.389, board_thickness - (stencil_thickness/2)]) D13_w_hole();
    translate (v=[50.114, 14.249, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[54.991, 14.249, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[8.763, 31.242, board_thickness - (stencil_thickness/2)]) D14_w_hole();
    translate (v=[8.763, 37.338, board_thickness - (stencil_thickness/2)]) D14_w_hole();
    translate (v=[3.937, 34.290, board_thickness - (stencil_thickness/2)]) D14_w_hole();
    translate (v=[14.808, 29.312, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[14.910, 19.075, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[12.370, 23.647, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[29.642, 21.133, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[26.365, 6.096, board_thickness - (stencil_thickness/2)]) D17_w_hole();
    translate (v=[55.220, 10.312, board_thickness - (stencil_thickness/2)]) D18_w_hole();
    translate (v=[50.140, 2.769, board_thickness - (stencil_thickness/2)]) D18_w_hole();

    // subtract the stencils
    hull() {
      translate (v=[14.910, 22.835, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[14.910, 19.837, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[12.370, 19.837, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[12.370, 22.835, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[52.781, 20.422, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[54.737, 14.986, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[50.114, 15.037, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[49.987, 20.371, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[55.169, 11.024, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[55.042, 13.487, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[50.140, 11.100, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[50.114, 13.487, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[50.825, 2.769, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[54.508, 2.718, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[14.834, 28.524, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[14.884, 24.460, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[17.374, 28.524, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[17.424, 24.460, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[27.153, 21.006, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[28.880, 21.107, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[25.603, 6.096, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[17.501, 6.147, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[17.501, 6.147, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[17.450, 22.835, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[44.882, 20.371, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[44.933, 6.045, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[45.314, 21.793, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[49.530, 28.118, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[14.910, 18.288, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[15.062, 2.946, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[15.062, 2.946, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[49.428, 2.794, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[14.808, 30.074, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[14.783, 33.350, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[47.447, 20.371, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[47.523, 6.909, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[21.946, 33.274, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[21.895, 28.245, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[47.523, 6.909, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[49.759, 3.353, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[14.783, 33.350, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[21.946, 33.274, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[26.391, 20.193, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[26.365, 16.993, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[44.933, 6.045, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[27.102, 6.096, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[12.014, 24.384, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[9.271, 30.175, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[14.351, 29.921, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[9.474, 36.398, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[7.772, 36.703, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[4.928, 34.925, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[21.895, 28.245, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[21.920, 33.249, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[44.983, 33.350, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[44.907, 29.540, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[21.920, 33.249, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[44.983, 33.350, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[48.209, 28.753, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[49.200, 28.753, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[26.746, 26.797, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[29.286, 21.819, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[19.761, 10.566, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[25.730, 6.528, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[19.456, 26.848, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[19.761, 10.566, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[17.856, 28.727, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[19.456, 26.848, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[21.895, 26.695, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[21.895, 21.742, board_thickness - (stencil_thickness/2)]) D19();
    }
  }
}

module stencil() {
  // Scale the board 
  scale(v=[1.0,1.0,1.0]) union() {
    // create the stand
    stand (66.5988, 40.03039999999999, board_thickness);

    // add the flashes
    translate (v=[14.808, 29.312, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[17.348, 29.312, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[14.910, 19.075, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[12.370, 19.075, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[12.370, 23.647, board_thickness - (stencil_thickness/2)]) D11();
    translate (v=[14.910, 23.647, board_thickness - (stencil_thickness/2)]) D11();
    translate (v=[17.450, 23.647, board_thickness - (stencil_thickness/2)]) D11();
    translate (v=[29.642, 21.133, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[29.642, 28.753, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[32.182, 21.133, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[32.182, 28.753, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[34.722, 21.133, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[34.722, 28.753, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[37.262, 21.133, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[37.262, 28.753, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[39.802, 21.133, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[39.802, 28.753, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[42.342, 21.133, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[42.342, 28.753, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[44.882, 21.133, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[44.882, 28.753, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[47.422, 21.133, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[47.422, 28.753, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[49.962, 21.133, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[49.962, 28.753, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[52.502, 21.133, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[52.502, 28.753, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[55.042, 21.133, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[55.042, 28.753, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[57.582, 21.133, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[57.582, 28.753, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[60.122, 21.133, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[60.122, 28.753, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[62.662, 21.133, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[62.662, 28.753, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[26.365, 6.096, board_thickness - (stencil_thickness/2)]) D12();
    translate (v=[26.365, 16.256, board_thickness - (stencil_thickness/2)]) D12();
    translate (v=[26.391, 27.483, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[26.391, 20.980, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[21.895, 27.483, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[21.895, 20.980, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[55.220, 10.312, board_thickness - (stencil_thickness/2)]) D13();
    translate (v=[55.220, 2.692, board_thickness - (stencil_thickness/2)]) D13();
    translate (v=[50.140, 2.769, board_thickness - (stencil_thickness/2)]) D13();
    translate (v=[50.140, 10.389, board_thickness - (stencil_thickness/2)]) D13();
    translate (v=[50.114, 14.249, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[54.991, 14.249, board_thickness - (stencil_thickness/2)]) D10();
    translate (v=[8.763, 31.242, board_thickness - (stencil_thickness/2)]) D14();
    translate (v=[8.763, 37.338, board_thickness - (stencil_thickness/2)]) D14();
    translate (v=[3.937, 34.290, board_thickness - (stencil_thickness/2)]) D14();
    translate (v=[14.808, 29.312, board_thickness - (stencil_thickness/2)]) D15();
    translate (v=[14.910, 19.075, board_thickness - (stencil_thickness/2)]) D15();
    translate (v=[12.370, 23.647, board_thickness - (stencil_thickness/2)]) D16();
    translate (v=[29.642, 21.133, board_thickness - (stencil_thickness/2)]) D15();
    translate (v=[26.365, 6.096, board_thickness - (stencil_thickness/2)]) D17();
    translate (v=[55.220, 10.312, board_thickness - (stencil_thickness/2)]) D18();
    translate (v=[50.140, 2.769, board_thickness - (stencil_thickness/2)]) D18();
    // add the stencils
    hull() {
      translate (v=[14.910, 22.835, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[14.910, 19.837, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[12.370, 19.837, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[12.370, 22.835, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[52.781, 20.422, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[54.737, 14.986, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[50.114, 15.037, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[49.987, 20.371, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[55.169, 11.024, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[55.042, 13.487, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[50.140, 11.100, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[50.114, 13.487, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[50.825, 2.769, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[54.508, 2.718, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[14.834, 28.524, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[14.884, 24.460, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[17.374, 28.524, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[17.424, 24.460, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[27.153, 21.006, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[28.880, 21.107, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[25.603, 6.096, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[17.501, 6.147, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[17.501, 6.147, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[17.450, 22.835, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[44.882, 20.371, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[44.933, 6.045, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[45.314, 21.793, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[49.530, 28.118, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[14.910, 18.288, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[15.062, 2.946, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[15.062, 2.946, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[49.428, 2.794, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[14.808, 30.074, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[14.783, 33.350, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[47.447, 20.371, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[47.523, 6.909, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[21.946, 33.274, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[21.895, 28.245, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[47.523, 6.909, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[49.759, 3.353, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[14.783, 33.350, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[21.946, 33.274, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[26.391, 20.193, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[26.365, 16.993, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[44.933, 6.045, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[27.102, 6.096, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[12.014, 24.384, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[9.271, 30.175, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[14.351, 29.921, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[9.474, 36.398, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[7.772, 36.703, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[4.928, 34.925, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[21.895, 28.245, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[21.920, 33.249, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[44.983, 33.350, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[44.907, 29.540, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[21.920, 33.249, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[44.983, 33.350, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[48.209, 28.753, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[49.200, 28.753, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[26.746, 26.797, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[29.286, 21.819, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[19.761, 10.566, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[25.730, 6.528, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[19.456, 26.848, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[19.761, 10.566, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[17.856, 28.727, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[19.456, 26.848, board_thickness - (stencil_thickness/2)]) D19();
    }
    hull() {
      translate (v=[21.895, 26.695, board_thickness - (stencil_thickness/2)]) D19();
      translate (v=[21.895, 21.742, board_thickness - (stencil_thickness/2)]) D19();
    }
  }
}
