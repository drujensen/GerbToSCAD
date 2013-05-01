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

board_thickness = 1.6;    //Change this line yourself to alter board thickness
stencil_thickness = 0.4;  //Change this line yourself to alter gap thickness
hole_size = 0.4;          //Change this line yourself to alter size of the hole

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
    gerb_circle(1.5999968, hole_size);
}
module D10() {
    gerb_circle(1.5999968);
}
module D11_w_hole() {
    gerb_circle(1.9049999999999998, hole_size);
}
module D11() {
    gerb_circle(1.9049999999999998);
}
module D12_w_hole() {
    gerb_circle(1.9811999999999999, hole_size);
}
module D12() {
    gerb_circle(1.9811999999999999);
}
module D13_w_hole() {
    gerb_rectangle(1.5999968, 1.5999968, hole_size);
}
module D13() {
    gerb_rectangle(1.5999968, 1.5999968);
}
module D14_w_hole() {
    gerb_rectangle(1.9049999999999998, 1.9049999999999998, hole_size);
}
module D14() {
    gerb_rectangle(1.9049999999999998, 1.9049999999999998);
}
module D15_w_hole() {
    gerb_rectangle(1.9811999999999999, 1.9811999999999999, hole_size);
}
module D15() {
    gerb_rectangle(1.9811999999999999, 1.9811999999999999);
}
module D16_w_hole() {
    gerb_circle(0.6096, hole_size);
}
module D16() {
    gerb_circle(0.6096);
}

// Scale the board 
scale(v=[1.0,1.0,1.0]) difference(){

    // First draw the solid part
    translate(v=[9.601199999999999, 11.252199999999998,board_thickness/2]) cube (size = [19.202399999999997, 22.504399999999997, board_thickness], center = true);

    // Next subtract each aperture flash from it
    translate (v=[14.681, 6.223, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[14.681, 8.712, board_thickness - (stencil_thickness/2)]) D10_w_hole();
    translate (v=[4.521, 16.332, board_thickness - (stencil_thickness/2)]) D11_w_hole();
    translate (v=[14.681, 16.332, board_thickness - (stencil_thickness/2)]) D11_w_hole();
    translate (v=[7.061, 6.172, board_thickness - (stencil_thickness/2)]) D12_w_hole();
    translate (v=[4.521, 6.172, board_thickness - (stencil_thickness/2)]) D12_w_hole();
    translate (v=[14.681, 6.223, board_thickness - (stencil_thickness/2)]) D13_w_hole();
    translate (v=[4.521, 16.332, board_thickness - (stencil_thickness/2)]) D14_w_hole();
    translate (v=[7.061, 6.172, board_thickness - (stencil_thickness/2)]) D15_w_hole();

    // Last subtract the stencils from it
      hull() {
        translate (v=[4.521, 6.833, board_thickness - (stencil_thickness/2)]) D16();
        translate (v=[4.521, 15.697, board_thickness - (stencil_thickness/2)]) D16();
      }
      hull() {
        translate (v=[14.097, 6.198, board_thickness - (stencil_thickness/2)]) D16();
        translate (v=[7.696, 6.172, board_thickness - (stencil_thickness/2)]) D16();
      }
      hull() {
        translate (v=[14.681, 9.296, board_thickness - (stencil_thickness/2)]) D16();
        translate (v=[14.681, 16.332, board_thickness - (stencil_thickness/2)]) D16();
      }
}
