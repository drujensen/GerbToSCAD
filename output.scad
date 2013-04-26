//    Aperture primitives are part of GenPaintSCAD.rb
//    Copyright (C) 2013 Dru Jensen
//
//    GenPaintSCAD is free software: you can redistribute it and/or modify
//    it under the terms of the GNU General Public License as published by
//    the Free Software Foundation, either version 3 of the License, or
//    (at your option) any later version.
//
//    GenPaintSCAD is distributed in the hope that it will be useful,
//    but WITHOUT ANY WARRANTY; without even the implied warranty of
//    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//    GNU General Public License for more details.
//
//    You should have received a copy of the GNU General Public License
//    along with this program.  If not, see <http://www.gnu.org/licenses/>.
$fn=20;

board_thickness = 1.6;  //Change this line yourself to alter board thickness
stencil_thickness = 0.2;  //Change this line yourself to alter gap thickness

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

module flash_D10() {
    gerb_circle(0.075000, 0.015748031496062995);
}
module D10() {
    gerb_circle(0.075000);
}
module flash_D11() {
    gerb_circle(0.082000, 0.015748031496062995);
}
module D11() {
    gerb_circle(0.082000);
}
module flash_D12() {
    gerb_circle(0.067000, 0.015748031496062995);
}
module D12() {
    gerb_circle(0.067000);
}
module flash_D13() {
    gerb_circle(0.054000, 0.015748031496062995);
}
module D13() {
    gerb_circle(0.054000);
}
module flash_D14() {
    gerb_circle(0.140000, 0.015748031496062995);
}
module D14() {
    gerb_circle(0.140000);
}
module flash_D15() {
    gerb_rectangle(0.075000, 0.075000, 0.015748031496062995);
}
module D15() {
    gerb_rectangle(0.075000, 0.075000);
}
module flash_D16() {
    gerb_rectangle(0.082000, 0.082000, 0.015748031496062995);
}
module D16() {
    gerb_rectangle(0.082000, 0.082000);
}
module flash_D17() {
    gerb_rectangle(0.067000, 0.067000, 0.015748031496062995);
}
module D17() {
    gerb_rectangle(0.067000, 0.067000);
}
module flash_D18() {
    gerb_rectangle(0.054000, 0.054000, 0.015748031496062995);
}
module D18() {
    gerb_rectangle(0.054000, 0.054000);
}
module flash_D19() {
    gerb_circle(0.033333, 0.015748031496062995);
}
module D19() {
    gerb_circle(0.033333);
}
difference(){

    // First draw the solid part
    scale(v=[25.4,25.4,1]) translate(v=[1.3110000000000002, 0.7879999999999999,board_thickness/2]) cube (size = [2.6220000000000003, 1.5759999999999998, board_thickness], center = true);

    // Then subtract each aperture flash from it
    scale(v=[25.4,25.4,1]) translate (v=[0.583, 1.154, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[0.683, 1.154, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[0.587, 0.751, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[0.487, 0.751, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[0.487, 0.931, board_thickness - (stencil_thickness/2)]) flash_D11();
    scale(v=[25.4,25.4,1]) translate (v=[0.587, 0.931, board_thickness - (stencil_thickness/2)]) flash_D11();
    scale(v=[25.4,25.4,1]) translate (v=[0.687, 0.931, board_thickness - (stencil_thickness/2)]) flash_D11();
    scale(v=[25.4,25.4,1]) translate (v=[1.167, 0.832, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[1.167, 1.132, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[1.267, 0.832, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[1.267, 1.132, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[1.367, 0.832, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[1.367, 1.132, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[1.467, 0.832, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[1.467, 1.132, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[1.567, 0.832, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[1.567, 1.132, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[1.667, 0.832, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[1.667, 1.132, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[1.767, 0.832, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[1.767, 1.132, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[1.867, 0.832, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[1.867, 1.132, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[1.967, 0.832, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[1.967, 1.132, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[2.067, 0.832, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[2.067, 1.132, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[2.167, 0.832, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[2.167, 1.132, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[2.267, 0.832, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[2.267, 1.132, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[2.367, 0.832, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[2.367, 1.132, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[2.467, 0.832, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[2.467, 1.132, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[1.038, 0.240, board_thickness - (stencil_thickness/2)]) flash_D12();
    scale(v=[25.4,25.4,1]) translate (v=[1.038, 0.640, board_thickness - (stencil_thickness/2)]) flash_D12();
    scale(v=[25.4,25.4,1]) translate (v=[1.039, 1.082, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[1.039, 0.826, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[0.862, 1.082, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[0.862, 0.826, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[2.174, 0.406, board_thickness - (stencil_thickness/2)]) flash_D13();
    scale(v=[25.4,25.4,1]) translate (v=[2.174, 0.106, board_thickness - (stencil_thickness/2)]) flash_D13();
    scale(v=[25.4,25.4,1]) translate (v=[1.974, 0.109, board_thickness - (stencil_thickness/2)]) flash_D13();
    scale(v=[25.4,25.4,1]) translate (v=[1.974, 0.409, board_thickness - (stencil_thickness/2)]) flash_D13();
    scale(v=[25.4,25.4,1]) translate (v=[1.973, 0.561, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[2.165, 0.561, board_thickness - (stencil_thickness/2)]) flash_D10();
    scale(v=[25.4,25.4,1]) translate (v=[0.345, 1.230, board_thickness - (stencil_thickness/2)]) flash_D14();
    scale(v=[25.4,25.4,1]) translate (v=[0.345, 1.470, board_thickness - (stencil_thickness/2)]) flash_D14();
    scale(v=[25.4,25.4,1]) translate (v=[0.155, 1.350, board_thickness - (stencil_thickness/2)]) flash_D14();
    scale(v=[25.4,25.4,1]) translate (v=[0.583, 1.154, board_thickness - (stencil_thickness/2)]) flash_D15();
    scale(v=[25.4,25.4,1]) translate (v=[0.587, 0.751, board_thickness - (stencil_thickness/2)]) flash_D15();
    scale(v=[25.4,25.4,1]) translate (v=[0.487, 0.931, board_thickness - (stencil_thickness/2)]) flash_D16();
    scale(v=[25.4,25.4,1]) translate (v=[1.167, 0.832, board_thickness - (stencil_thickness/2)]) flash_D15();
    scale(v=[25.4,25.4,1]) translate (v=[1.038, 0.240, board_thickness - (stencil_thickness/2)]) flash_D17();
    scale(v=[25.4,25.4,1]) translate (v=[2.174, 0.406, board_thickness - (stencil_thickness/2)]) flash_D18();
    scale(v=[25.4,25.4,1]) translate (v=[1.974, 0.109, board_thickness - (stencil_thickness/2)]) flash_D18();
    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[0.587, 0.899, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[0.587, 0.781, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[0.487, 0.781, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[0.487, 0.899, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[2.078, 0.804, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[2.155, 0.590, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[1.973, 0.592, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[1.968, 0.802, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[2.172, 0.434, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[2.167, 0.531, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[1.974, 0.437, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[1.973, 0.531, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[2.001, 0.109, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[2.146, 0.107, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[0.584, 1.123, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[0.586, 0.963, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[0.684, 1.123, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[0.686, 0.963, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[1.069, 0.827, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[1.137, 0.831, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[1.008, 0.240, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[0.689, 0.242, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[0.689, 0.242, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[0.687, 0.899, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[1.767, 0.802, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[1.769, 0.238, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[1.784, 0.858, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[1.950, 1.107, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[0.587, 0.720, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[0.593, 0.116, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[0.593, 0.116, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[1.946, 0.110, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[0.583, 1.184, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[0.582, 1.313, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[1.868, 0.802, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[1.871, 0.272, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[0.864, 1.310, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[0.862, 1.112, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[1.871, 0.272, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[1.959, 0.132, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[0.582, 1.313, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[0.864, 1.310, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[1.039, 0.795, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[1.038, 0.669, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[1.769, 0.238, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[1.067, 0.240, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[0.473, 0.960, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[0.365, 1.188, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[0.565, 1.178, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[0.373, 1.433, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[0.306, 1.445, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[0.194, 1.375, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[0.862, 1.112, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[0.863, 1.309, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[1.771, 1.313, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[1.768, 1.163, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[0.863, 1.309, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[1.771, 1.313, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[1.898, 1.132, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[1.937, 1.132, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[1.053, 1.055, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[1.153, 0.859, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[0.778, 0.416, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[1.013, 0.257, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[0.766, 1.057, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[0.778, 0.416, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[0.703, 1.131, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[0.766, 1.057, board_thickness - (stencil_thickness/2)]) D19();
 
      }

    scale(v=[25.4,25.4,1]) 
      hull() { 
  
        translate (v=[0.862, 1.051, board_thickness - (stencil_thickness/2)]) D19();
  
        translate (v=[0.862, 0.856, board_thickness - (stencil_thickness/2)]) D19();
 
      }

}
