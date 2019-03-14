require_relative "./libraries/lib_grids.rb"
require_relative "./libraries/lib_math.rb"
require "chunky_png"
width = 32; height = 32;
png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color.rgba(0, 0, 0, 255))
  grid = Grid.new(width,height,0)
  grid.randomize_points(2)
  p measure { grid.apply_voronoi(png,5); }
  p measure { grid.apply_voronoi(png,9); }
  p measure { grid.apply_voronoi(png,13); }
  grid.draw(png);
png.save("output.png", :interlace => false)
