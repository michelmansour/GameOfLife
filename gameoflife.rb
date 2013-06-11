class GameOfLife
  
  @width
  @height
  @cells
  @border_rule
  
  def initialize(width, height, live_cells, border_rule=:standard)
    @width = width
    @height = height
    @cells = Array.new(@width) { Array.new(@height, :dead) }
    live_cells.each { |x, y| @cells[x][y] = :alive }
    @border_rule = border_rule
  end
  
  def print_world(alive_str='*', dead_str='-')
    (0...@height).each do |y|
      (0...@width).each do |x|
        if status(x, y) == :alive
          print alive_str
        else
          print dead_str
        end
        print " "
      end
      print "\n"
    end
  end

  def run_generation
    new_cells = Array.new(@width) { Array.new(@height, :dead) }
    (0...@width).each do |x|
      (0...@height).each do |y|
        new_cells[x][y] = next_cell_state(x, y)
      end
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

  def status(x, y)
    @cells[x][y]
  end
  
  def out_of_bounds?(x, y)
    x >= @width || x < 0 || y >= @height || y < 0
  end

  def border_neighbor(x, y)
    new_x = x
    new_y = y
    if @border_rule == :torus
      if x < 0
        new_x = @width - 1
      elsif x >= @width
        new_x = 0
      end
      if y < 0
        new_y = @height - 1
      elsif y >= @height
        new_y = 0
      end
    end

    [new_x, new_y]
  end

  def living_neighbors(x, y)
    [[0, -1], [1, -1], [1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1]].inject(0) do |result, delta|
      neighbor = border_neighbor(x + delta[0], y + delta[1])
      if out_of_bounds?(neighbor[0], neighbor[1]) || status(neighbor[0], neighbor[1]) == :dead
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

#  private :status, :out_of_bounds?, :border_neighbor, :living_neighbors, :next_cell_state
  
end


