require_relative "./libraries/lib_grids.rb"
require_relative "./libraries/lib_math.rb"
require "chunky_png"
width = 512; height = 512;
png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color::TRANSPARENT)
  grid = Grid.new(width,height,0)
  grid.randomize_points(512,1)
  grid.draw(png);
png.save("output.png", :interlace => false)
