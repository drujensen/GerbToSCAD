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

board_thickness = 1.6;    //Change this line yourself to alter board thickness
stencil_thickness = 1;  //Change this line yourself to alter gap thickness
hole_size = 1;          //Change this line yourself to alter size of the hole

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


//////////////////////////////////////////////////////////////////////////////////////////////////
// End of aperture primitives -- everything below is generated from the input gerber    
//////////////////////////////////////////////////////////////////////////////////////////////////

// Start of aperture definitions

module D10_w_hole() {
    gerb_circle(2.0827999999999998, hole_size);
}
module D10() {
    gerb_circle(2.0827999999999998);
}
module D11_w_hole() {
    gerb_circle(1.9811999999999999, hole_size);
}
module D11() {
    gerb_circle(1.9811999999999999);
}
module D12_w_hole() {
    gerb_circle(1.651, hole_size);
}
module D12() {
    gerb_circle(1.651);
}
module D13_w_hole() {
    gerb_circle(1.5999968, hole_size);
}
module D13() {
    gerb_circle(1.5999968);
}
module D14_w_hole() {
    gerb_circle(1.507998, hole_size);
}
module D14() {
    gerb_circle(1.507998);
}
module D15_w_hole() {
    gerb_circle(2.1159978, hole_size);
}
module D15() {
    gerb_circle(2.1159978);
}
module D16_w_hole() {
    gerb_circle(1.9049999999999998, hole_size);
}
module D16() {
    gerb_circle(1.9049999999999998);
}
module D17_w_hole() {
    gerb_circle(1.8014949999999998, hole_size);
}
module D17() {
    gerb_circle(1.8014949999999998);
}
module D18_w_hole() {
    gerb_circle(1.7999964, hole_size);
}
module D18() {
    gerb_circle(1.7999964);
}
module D19_w_hole() {
    gerb_rectangle(2.0827999999999998, 2.0827999999999998, hole_size);
}
module D19() {
    gerb_rectangle(2.0827999999999998, 2.0827999999999998);
}
module D20_w_hole() {
    gerb_rectangle(1.5999968, 1.5999968, hole_size);
}
module D20() {
    gerb_rectangle(1.5999968, 1.5999968);
}
module D21_w_hole() {
    gerb_circle(0.6096, hole_size);
}
module D21() {
    gerb_circle(0.6096);
}
module D22_w_hole() {
    gerb_circle(0.508, hole_size);
}
module D22() {
    gerb_circle(0.508);
}

// Scale the board 
scale(v=[1.0,1.0,1.0]) difference(){

    // First draw the solid part
    translate(v=[35.47109999999999, 15.493999999999996,board_thickness/2]) cube (size = [70.94219999999999, 30.987999999999992, board_thickness], center = true);

    // Next subtract each aperture flash from it
    translate (v=[67.208, 14.199, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[64.668, 14.199, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[62.128, 14.199, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[64.668, 19.279, board_thickness - (stencil_thickness/2)]) D11_w_hole();
    translate (v=[67.208, 19.279, board_thickness - (stencil_thickness/2)]) D11_w_hole();
    translate (v=[67.234, 6.579, board_thickness - (stencil_thickness/2)]) D12_w_hole();
    translate (v=[64.694, 6.579, board_thickness - (stencil_thickness/2)]) D12_w_hole();
    translate (v=[59.588, 6.579, board_thickness - (stencil_thickness/2)]) D12_w_hole();
    translate (v=[62.128, 6.579, board_thickness - (stencil_thickness/2)]) D12_w_hole();
    translate (v=[46.888, 24.359, board_thickness - (stencil_thickness/2)]) D11_w_hole();
    translate (v=[21.488, 4.064, board_thickness - (stencil_thickness/2)]) D13_w_hole();
    translate (v=[21.488, 6.579, board_thickness - (stencil_thickness/2)]) D13_w_hole();
    translate (v=[51.968, 19.279, board_thickness - (stencil_thickness/2)]) D14_w_hole();
    translate (v=[51.968, 11.659, board_thickness - (stencil_thickness/2)]) D14_w_hole();
    translate (v=[46.888, 19.279, board_thickness - (stencil_thickness/2)]) D14_w_hole();
    translate (v=[46.888, 11.659, board_thickness - (stencil_thickness/2)]) D14_w_hole();
    translate (v=[62.128, 21.819, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[59.588, 21.819, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[57.048, 21.819, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[54.508, 21.819, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[62.128, 24.359, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[59.588, 24.359, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[57.048, 24.359, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[54.508, 24.359, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[44.348, 19.279, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[44.348, 11.659, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[41.808, 19.279, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[41.808, 11.659, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[39.268, 19.279, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[39.268, 11.659, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[36.728, 19.279, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[36.728, 11.659, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[34.188, 19.279, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[34.188, 11.659, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[31.648, 19.279, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[31.648, 11.659, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[29.108, 19.279, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[29.108, 11.659, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[26.568, 19.279, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[26.568, 11.659, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[24.028, 19.279, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[24.028, 11.659, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[21.488, 19.279, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[21.488, 11.659, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[18.948, 19.279, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[18.948, 11.659, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[16.408, 19.279, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[16.408, 11.659, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[13.868, 19.279, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[13.868, 11.659, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[11.328, 19.279, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[11.328, 11.659, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[44.348, 6.579, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[41.808, 6.579, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[39.268, 6.579, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[36.728, 6.579, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[34.188, 6.579, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[31.648, 6.579, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[29.108, 6.579, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[3.708, 4.039, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[3.708, 6.579, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[3.708, 9.119, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[3.708, 11.659, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[3.708, 14.199, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[3.708, 16.739, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[3.708, 19.279, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[3.708, 21.819, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[3.708, 24.359, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[41.808, 24.359, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[39.268, 24.359, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[36.728, 24.359, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[34.188, 24.359, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[31.648, 24.359, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[54.508, 6.579, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[51.968, 6.579, board_thickness - (stencil_thickness/2)]) D15_w_hole();
    translate (v=[19.126, 24.359, board_thickness - (stencil_thickness/2)]) D17_w_hole();
    translate (v=[24.028, 24.359, board_thickness - (stencil_thickness/2)]) D18_w_hole();
    translate (v=[26.568, 26.899, board_thickness - (stencil_thickness/2)]) D12_w_hole();
    translate (v=[29.108, 26.899, board_thickness - (stencil_thickness/2)]) D12_w_hole();
    translate (v=[16.408, 26.899, board_thickness - (stencil_thickness/2)]) D12_w_hole();
    translate (v=[13.868, 26.899, board_thickness - (stencil_thickness/2)]) D12_w_hole();
    translate (v=[57.048, 19.279, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[57.048, 9.119, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[34.188, 4.039, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[24.028, 4.039, board_thickness - (stencil_thickness/2)]) D16_w_hole();
    translate (v=[67.208, 14.199, board_thickness - (stencil_thickness/2)]) D19_w_hole();
    translate (v=[21.488, 4.064, board_thickness - (stencil_thickness/2)]) D20_w_hole();

    // Last subtract the stencils from it
      hull() {
        translate (v=[51.943, 24.333, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[47.676, 24.359, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[51.968, 20.066, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[51.943, 24.333, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[56.337, 19.279, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[52.756, 19.279, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[46.888, 14.199, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[29.134, 14.199, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[29.134, 14.199, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[29.134, 12.370, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[46.888, 12.446, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[46.888, 14.199, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[51.156, 6.579, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[46.888, 6.604, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[46.888, 6.604, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[46.888, 10.871, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[26.619, 21.793, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[29.134, 21.793, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[29.134, 21.793, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[29.134, 26.264, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[26.594, 19.990, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[26.619, 21.793, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[26.619, 6.604, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[24.079, 6.604, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[24.079, 6.604, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[24.054, 10.922, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[26.594, 4.039, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[26.619, 6.604, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[33.477, 4.039, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[26.594, 4.039, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[59.639, 21.819, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[61.316, 21.819, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[59.639, 9.169, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[59.639, 21.819, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[57.785, 9.119, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[59.639, 9.169, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[59.639, 9.169, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[59.614, 7.214, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[57.785, 9.119, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[59.639, 9.169, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[67.208, 13.386, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[67.208, 7.214, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[64.668, 13.386, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[64.668, 7.214, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[67.208, 15.011, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[67.208, 18.517, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[64.643, 24.308, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[62.967, 24.333, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[64.668, 20.041, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[64.643, 24.308, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[64.668, 15.011, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[64.668, 18.517, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[34.188, 7.417, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[34.188, 10.922, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[41.808, 10.922, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[41.808, 7.417, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[39.268, 7.417, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[39.268, 10.922, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[36.728, 10.922, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[36.728, 7.417, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[24.028, 19.990, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[24.028, 23.673, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[26.619, 24.333, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[24.714, 24.359, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[26.594, 26.264, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[26.619, 24.333, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[28.753, 7.315, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[26.899, 10.998, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[21.463, 24.333, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[19.812, 24.359, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[21.488, 19.990, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[21.463, 24.333, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[16.459, 24.308, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[18.466, 24.333, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[14.326, 26.441, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[16.459, 24.308, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[59.563, 14.199, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[61.316, 14.199, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[59.588, 7.214, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[59.563, 14.199, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[44.348, 24.333, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[46.126, 24.359, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[44.348, 19.990, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[44.348, 24.333, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[23.317, 4.039, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[22.174, 4.064, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[41.808, 23.520, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[41.808, 19.990, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[36.728, 23.520, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[36.728, 19.990, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[34.188, 23.520, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[34.188, 19.990, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[31.648, 23.520, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[31.648, 19.990, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[39.268, 23.520, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[39.268, 19.990, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[44.348, 7.417, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[44.348, 10.922, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[11.328, 24.308, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[15.900, 19.787, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[4.521, 22.073, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[11.328, 24.308, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[11.328, 1.524, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[4.521, 3.785, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[20.980, 11.151, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[11.328, 1.524, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[11.328, 26.924, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[18.440, 19.787, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[4.521, 24.613, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[11.328, 26.924, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[11.328, 21.819, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[13.360, 19.787, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[4.521, 19.533, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[11.328, 21.819, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[11.328, 16.688, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[11.328, 18.542, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[4.547, 16.739, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[11.328, 16.688, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[11.328, 4.039, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[18.440, 11.151, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[4.521, 6.325, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[11.328, 4.039, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[11.328, 6.553, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[15.900, 11.151, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[4.521, 8.839, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[11.328, 6.553, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[11.328, 9.169, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[13.360, 11.151, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[4.521, 11.405, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[11.328, 9.169, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[11.328, 14.173, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[11.328, 12.370, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[4.547, 14.199, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[11.328, 14.173, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[16.434, 29.464, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[16.434, 27.534, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[29.134, 29.464, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[16.434, 29.464, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[29.134, 27.534, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[29.134, 29.464, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[21.488, 7.264, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[21.488, 10.922, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[54.508, 4.039, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[34.925, 4.039, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[54.508, 5.740, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[54.508, 4.039, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[54.559, 9.144, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[56.337, 9.119, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[54.534, 7.417, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[54.559, 9.144, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[26.619, 14.199, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[29.134, 14.199, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[29.134, 14.199, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[29.134, 12.370, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[26.594, 18.542, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[26.619, 14.199, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[31.648, 7.417, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[31.648, 10.922, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[29.134, 16.739, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[29.134, 18.542, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[46.888, 16.739, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[29.134, 16.739, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[54.559, 14.199, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[49.403, 14.199, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[49.403, 14.199, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[46.888, 16.739, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[54.534, 7.417, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[54.559, 14.199, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[56.236, 21.819, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[55.347, 21.819, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[57.887, 21.819, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[58.776, 21.819, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[60.427, 21.819, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[61.316, 21.819, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[60.427, 24.359, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[61.316, 24.359, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[58.776, 24.359, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[57.887, 24.359, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[56.236, 24.359, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[55.347, 24.359, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[29.743, 26.899, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[31.699, 26.899, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[31.699, 26.899, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[54.508, 26.899, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[54.508, 26.899, board_thickness - (stencil_thickness/2)]) D21();
        translate (v=[54.508, 25.197, board_thickness - (stencil_thickness/2)]) D21();
      }
      hull() {
        translate (v=[45.060, 18.567, board_thickness - (stencil_thickness/2)]) D22();
        translate (v=[43.663, 18.567, board_thickness - (stencil_thickness/2)]) D22();
      }
      hull() {
        translate (v=[43.663, 18.567, board_thickness - (stencil_thickness/2)]) D22();
        translate (v=[43.663, 19.964, board_thickness - (stencil_thickness/2)]) D22();
      }
      hull() {
        translate (v=[43.663, 19.964, board_thickness - (stencil_thickness/2)]) D22();
        translate (v=[45.060, 19.964, board_thickness - (stencil_thickness/2)]) D22();
      }
      hull() {
        translate (v=[45.060, 19.964, board_thickness - (stencil_thickness/2)]) D22();
        translate (v=[45.060, 18.567, board_thickness - (stencil_thickness/2)]) D22();
      }
}
