require_relative "./libraries/lib_grids.rb"
require_relative "./libraries/lib_math.rb"
grid = Grid.new(32,32,0)
#grid.randomize_points(16,-1)
grid.add_circle(8,8,8,2)
grid.log();
