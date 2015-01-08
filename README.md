GerbPaintSCAD
==========

Jerrill Johnson from the G+ 3D community provided the idea of using a simple process to create PCB boards using conductive paint.  Watch the video to see how this process is performed.

https://www.youtube.com/watch?feature=player_embedded&v=jCzmQLZKNA8#!

This project is to convert a RS-274X extended Gerber Solder Stencil into a SCAD file that can be 3D printed using the process Jerrill presents.

Credits go to https://github.com/bluecoast/SolderSCAD for a good starting point.

Usage: GerbToSCAD {inputfile} {outputfile}

The inputfile should be the .gbl file format.
The outputfile will be .scad file format.

Requires Ruby 1.9.2 or greater
