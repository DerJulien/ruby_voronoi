require_relative "./libraries/lib_grids.rb"
require_relative "./libraries/lib_math.rb"
require "chunky_png"
width = 64; height = 64;
png = ChunkyPNG::Image.new(width, height, ChunkyPNG::Color.rgba(0, 0, 0, 255))
  grid = Grid.new(width,height,0)
    mr = 65; r = 1;
    mr.times do
      r+=1;
      p measure { grid.apply_voronoi(r) }
    end
  grid.draw(png);
png.save("output.png", :interlace => false)
