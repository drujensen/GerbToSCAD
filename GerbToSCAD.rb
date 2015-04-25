#!/usr/bin/env ruby

#    GerbPaintSCAD.rb -- script to convert gerber solder stencil file to OpenSCAD file for use with conductive paint.
#    version 0.1 -- April 25 2013
#    Copyright (C) 2013 Dru Jensen
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
#    Credit to SolderSCAD and Andrew Barrow of which many of the ideas on how to do this conversion came from his code.

require 'fileutils' #I know, no underscore is not ruby-like
include FileUtils

input_filename = "input.gbl"
output_filename = "output.scad"
aperture_filename = "aperture_primitives.dat"

if ARGV.length > 1
  output_filename = ARGV[1]
end
if ARGV.length > 0
  input_filename = ARGV[0]
  puts "Output file was not specified. Using default."
else
  puts "Input and Output file were not specified. Using defaults."
end

puts "Input File: #{input_filename}"
puts "Output File: #{output_filename}"

# data structures to hold data
unit_scale = 25.4
a_scale = 1.0
b_scale = 1.0
min_x = 10000
max_x = 0
min_y = 10000
max_y = 0

cur_ap = "D10"
ap_list = []
too_small = 0.01
cur_x = 0
cur_y = 0

flashes = ""
holes = ""
stencils = ""

output_file = File.open(output_filename, 'w')

output_file.write("// Generate the Board\n")
output_file.write("board();\n\n")
output_file.write("// Uncomment to generate the Stencil\n")
output_file.write("// stencil();\n\n")
output_file.write("\n")

# write the aperture modules to the output file
puts "Creating the apertures in: #{aperture_filename}"
output_file.write(File.read(aperture_filename))

# loop through the file and load the data
File.open(input_filename, 'r') do |input_file|
  while (line = input_file.gets)
    next if line[/^G04*/]
    puts "#{line}"
    
    if data = /%ASAXBY*%/.match(line)
    end
    
    #Format Specification
    if data = /%FS(.)(.)X(\d)(\d)Y(\d)(\d)\*%/.match(line)
      
      # TODO: Currently ignoring
      if data[1] == "L"
        leading_zeros = true
      else
        leading_zeros = false
      end
      
      # TODO: Currently ignoring
      if data[2] == "A"
        absolute = true
      else
        absolute = false
      end

      x_int=data[3].to_i
      x_dec=data[4].to_i
      y_int=data[5].to_i
      y_dec=data[6].to_i
      
    end
    
    #Mode inch or mm units
    if data = /%MO(..)\*%/.match(line)
      if data[1] == "IN"
        puts "Mode set to inch.  Converting to mm."
        unit_scale=25.4
      else
        unit_scale=1.0
      end
    end

    # TODO: Currently ignoring
    if data = /%OFA0B0*%/.match(line)
    end

    # TODO: Currently ignoring
    if data = /%SFA1.0B1.0*%/.match(line)
    end
    
    #Look for aperture circle and capture data
    if data = /%AD(D\d+)C,(\d+\.?\d+)\*%/.match(line)
      if (data[2].to_f < too_small)
        puts "Aperture too small. skipping..."
        next
      end
      ap_list << data[1]
      puts "found aperture #{data[1]} circle with radius #{data[2]}"
      output_file.write("module #{data[1]}_w_hole() {\n")
      output_file.write("  gerb_circle(#{data[2].to_f * unit_scale}, hole_size);\n")
      output_file.write("}\n")

      output_file.write("module #{data[1]}() {\n")
      output_file.write("  gerb_circle(#{data[2].to_f * unit_scale});\n")
      output_file.write("}\n")
    end

    #Look for aperture rectangle and capture data
    if data = /%AD(D\d+)R,(\d+\.?\d+)X(\d+\.?\d+)\*%/.match(line)
      if (data[2].to_f < too_small || data[3].to_f < too_small)
        puts "Aperture too small. skipping..."
        next
      end
      ap_list << data[1]     
      puts "found aperture #{data[1]} rectangle with X #{data[2]} and Y #{data[3]}"
      output_file.write("module #{data[1]}_w_hole() {\n")
      output_file.write("  gerb_rectangle(#{data[2].to_f * unit_scale}, #{data[3].to_f * unit_scale}, hole_size);\n")
      output_file.write("}\n")

      output_file.write("module #{data[1]}() {\n")
      output_file.write("  gerb_rectangle(#{data[2].to_f * unit_scale}, #{data[3].to_f * unit_scale});\n")
      output_file.write("}\n")
    end

    #Look for aperture obround and capture data
    if data = /%AD(D\d+)O,(\d+\.?\d+)X(\d+\.?\d+)\*%/.match(line)
      if (data[2].to_f < too_small || data[3].to_f < too_small)
        puts "Aperture too small. skipping..."
        next
      end
      ap_list << data[1]     
      puts "found aperture #{data[1]} obround with X #{data[2]} and Y #{data[3]}"
      output_file.write("module #{data[1]} {\n")
      output_file.write("  gerb_obround(#{data[2].to_f * unit_scale}, #{data[3].to_f * unit_scale});\n")
      output_file.write("}\n")
    end

    #Look for aperture polygon and capture data
    if data = /%AD(D\d+)P,(\d+\.?\d+)X(\d+\.?\d+)\*%/.match(line)
      if (data[2].to_f < too_small || data[3].to_f < too_small)
        puts "Aperture too small. skipping..."
        next
      end
      ap_list << data[1]     
      puts "found aperture #{data[1]} polygon with points #{data[2]}, #{data[3]}"
      output_file.write("module #{data[1]}() {\n")
      output_file.write("  gerb_polygon(#{data[2].to_f * unit_scale}, #{data[3].to_f * unit_scale});\n")
      output_file.write("}\n")
    end
    
    #Look for currently selected aperture
    if data = /^G54(D\d+)/.match(line)
      puts "change current aperture #{cur_ap} to #{data[1]}"
      cur_ap = data[1]
    end

    if not ap_list.include? cur_ap
      puts "aperture too small, skipping..."
      next
    end

    #Look for flashes.  Add a fixed size hole.  TODO: Import the drilling information
    if data = /X(\d+)Y(\d+)D03/.match(line)
      puts "flash #{cur_ap} at #{data[1]}, #{data[2]}"
      cur_x = data[1].to_f / (10 ** x_dec) * unit_scale
      cur_y = data[2].to_f / (10 ** y_dec) * unit_scale
      holes += "    translate (v=[#{"%2.3f" % cur_x}, #{"%2.3f" % cur_y}, board_thickness - (stencil_thickness/2)]) #{cur_ap}_w_hole();\n"
      flashes += "    translate (v=[#{"%2.3f" % cur_x}, #{"%2.3f" % cur_y}, board_thickness - (stencil_thickness/2)]) #{cur_ap}();\n"
      min_x = cur_x if cur_x < min_x
      min_y = cur_y if cur_y < min_y
      max_x = cur_x if cur_x > max_x
      max_y = cur_y if cur_y > max_y
    end

    #Look for stencils
    if data = /X(\d+)Y(\d+)D01/.match(line)
      puts "stencil #{cur_ap} to #{data[1]}, #{data[2]}"
      save_x = cur_x
      save_y = cur_y
      cur_x = data[1].to_f / (10 ** x_dec) * unit_scale
      cur_y = data[2].to_f / (10 ** y_dec) * unit_scale
      stencils += <<-eos
    hull() {
      translate (v=[#{"%2.3f" % save_x}, #{"%2.3f" % save_y}, board_thickness - (stencil_thickness/2)]) #{cur_ap}();
      translate (v=[#{"%2.3f" % cur_x}, #{"%2.3f" % cur_y}, board_thickness - (stencil_thickness/2)]) #{cur_ap}();
    }
      eos
      min_x = cur_x if cur_x < min_x
      min_y = cur_y if cur_y < min_y
      max_x = cur_x if cur_x > max_x
      max_y = cur_y if cur_y > max_y
    end

    #Look for moves
    if data = /X(\d+)Y(\d+)D02/.match(line)
      puts "move to #{data[1]}, #{data[2]}"
      cur_x = data[1].to_f / (10 ** x_dec) * unit_scale
      cur_y = data[2].to_f / (10 ** y_dec) * unit_scale
    end

  end
end

x = (max_x-min_x) + (min_x * 2)
y = (max_y-min_y) + (min_y * 2)

#TODO a_scale and b_scale need to be set
output_file.write("module board() {\n")
output_file.write("  // scale the board \n")
output_file.write("  scale(v=[#{a_scale},#{b_scale},1.0]) difference(){\n") #put following at top of file
output_file.write("\n")
output_file.write("    // draw the solid part\n")
output_file.write("    translate(v=[#{x/2}, #{y/2},board_thickness/2]) cube (size = [#{x}, #{y}, board_thickness], center = true);\n")
output_file.write("\n")
output_file.write("    // subtract each aperture flash with holes\n")

# write the flashes
output_file.write(holes)

output_file.write("\n")
output_file.write("    // subtract the stencils\n")
# write the stencils
output_file.write(stencils)

output_file.write("  }\n")
output_file.write("}\n")

output_file.write("\n")
output_file.write("module stencil() {\n")
output_file.write("  // Scale the board \n")
output_file.write("  scale(v=[#{a_scale},#{b_scale},1.0]) union() {\n") #put following at top of file

output_file.write("    // create the stand\n")
output_file.write("    translate(v=[#{x/2}, #{y/2},board_thickness/2]) stand (#{x}, #{y}, board_thickness);\n")
output_file.write("\n")
output_file.write("    // add the flashes\n")
output_file.write(flashes)
output_file.write("    // add the stencils\n")
# write the stencils
output_file.write(stencils)

output_file.write("  }\n")
output_file.write("}\n")

# close the output file
puts "Done!"
output_file.close
