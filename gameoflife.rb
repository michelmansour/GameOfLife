##########################################################
# An implementation of Conway's Game of Life in Ruby
#
# (c) 2013 Michel Mansour
#
# To see it in action:
#
# From the command line:
#
#   gameoflife.rb -n N -a X1,Y1,X2,Y2,...
#       -n N, the size of the board
#       -a X1,Y1,... specifies which cells are alive
#                    to start
#
# Or from within Ruby (or irb):
#
# 1. Create an instance of the GameOfLife class
#    > gol = GameOfLife.new(5, [[1, 2], [2, 2], [3, 2]])
#
#   The first parameter is the size of the world
#   (which is a square). The second parameter is an
#   array of coordinates whose cells are alive.
#
#   > gol.print_world
#
#     -----
#     --*--
#     --*--
#     --*--
#     -----
#
#   Living cells are represented by *, dead ones by -.
#   These are optional parameters to print_world.
#
# 2. Advance a single generation:
#    > gol.run_generation
#    > gol.print_world
#
#    -----
#    -----
#    -***-
#    -----
#    -----
#
# 3. Run the world:
#    > gol.run
#
#    This will print out the state of the world after
#    each generation, pausing a moment between iterations
##########################################################

require 'optparse'

class GameOfLife

  @size
  @cells

  def initialize(n, live_cells)
    @size = n
    @cells = Array.new(@size) { Array.new(@size, :dead) }
    live_cells.each { |x, y| @cells[x][y] = :alive }
  end

  def status(x, y)
    @cells[x][y]
  end

  def print_world(alive_str='*', dead_str='-')
    @cells.each do |row|
      row.each do |cell|
        if cell == :alive
          print alive_str
        else
          print dead_str
        end
      end
      print "\n"
    end
  end

  def out_of_bounds?(x, y)
    x >= @size || x < 0 || y >= @size || y < 0
  end

  def living_neighbors(x, y)
    [[0, -1], [1, -1], [1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1]].inject(0) do |result, cell|
      if out_of_bounds?(x + cell[0], y + cell[1]) || status(x + cell[0], y + cell[1]) == :dead
        result
      else
        result + 1
      end
    end
  end

  def next_cell_state(x, y)
    status = status(x, y)
    num_live_neighbors = living_neighbors(x, y)
    if status == :alive and (num_live_neighbors < 2 || num_live_neighbors > 3)
      :dead
    elsif status == :dead and num_live_neighbors == 3
      :alive
    else
      status
    end
  end

  def run_generation
    new_cells = Array.new(@size) { Array.new(@size, :dead) }
    (0...@size).to_a.repeated_permutation(2) do |x, y| 
      new_cells[x][y] = next_cell_state(x, y)
    end
    @cells = new_cells
  end

  def run
    while true
      print_world
      print "\n=====================\n\n"
      sleep(0.5)
      run_generation
    end
  end
end

size = 5
live_cells = [[1,2], [2,2], [3,2]]

OptionParser.new do |o|
  o.banner = "Usage: gameoflife.rb [options]"
  o.on('-n N', Integer, "Size of the world") { |n| size = n; live_cells = [] }
  o.on('-a X1,Y1,X2,Y2,...', Array, "Living cells as coordinate pairs") do |a|
    if not a.length.even?
      print "Error: Must specify living cells as pairs"
      exit
    end
    live_cells = a.collect { |k| k.to_i }.each_slice(2).to_a
  end
  o.on_tail("-h", "--help", "Show this message") do
    puts o
    exit
  end
end.parse!

GameOfLife.new(size, live_cells).run
