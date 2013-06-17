require_relative 'gameoflife'

describe GameOfLife do
  describe "#out_of_bounds?" do
    it "returns true if x < 0" do
      gol = GameOfLife.new(1, 1, [])
      gol.out_of_bounds?(-1, 0).should eq(true)
    end
  end

  describe "#status" do
    it "returns :alive when cells are alive and :dead when cells are dead" do
      gol = GameOfLife.new(2, 2, [[0, 0]])
      gol.status(0,0).should eq(:alive)
      gol.status(1,1).should eq(:dead)
    end
  end

  describe "#border_neighbor" do
    it "returns the arguments if they are in bounds; otherwise returns the appropriate wrapped around value" do
      gol_std = GameOfLife.new(1, 1, [], :standard)
      gol_std.border_neighbor(0, 0).should eq([0, 0])
      gol_std.border_neighbor(-1, 0).should eq([-1, 0])
      gol_std.border_neighbor(0, -1).should eq([0, -1])
      gol_std.border_neighbor(2, 2).should eq([2, 2])

      gol_torus = GameOfLife.new(2, 2, [], :torus)
      gol_torus.border_neighbor(0, 0).should eq([0, 0])
      gol_torus.border_neighbor(-1, 0).should eq([1, 0])
      gol_torus.border_neighbor(0, -1).should eq([0, 1])
      gol_torus.border_neighbor(-1, -1).should eq([1, 1])
      gol_torus.border_neighbor(-3, 0).should eq([1, 0])
      gol_torus.border_neighbor(2, 0).should eq([0, 0])
      gol_torus.border_neighbor(0, 2).should eq([0, 0])
      gol_torus.border_neighbor(2, 2).should eq([0, 0])
      gol_torus.border_neighbor(0, 3).should eq([0, 0])
    end
  end

  describe "#neighbors" do
    it "returns the potential neighbors of a cell as an array of 8 cells" do
      gol_std = GameOfLife.new(5, 5, [], :standard)
      gol_std.neighbors(2, 2).should eq([[2, 1], [3, 1], [3, 2], [3, 3], [2, 3], [1, 3], [1, 2], [1, 1]])
      gol_std.neighbors(0, 0).should eq([[0, -1], [1, -1], [1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1]])

      gol_torus = GameOfLife.new(5, 5, [], :torus)
      gol_torus.neighbors(0, 0).should eq([[0, 4], [1, 4], [1, 0], [1, 1], [0, 1], [4, 1], [4, 0], [4, 4]])
    end
  end

  describe "#inbounds_neighbors" do
    it "returns an array of neighbors that are actually in the world" do
      gol = GameOfLife.new(5, 5, [], :standard)
      gol.inbounds_neighbors(2, 2).should eq([[2, 1], [3, 1], [3, 2], [3, 3], [2, 3], [1, 3], [1, 2], [1, 1]])
      gol.inbounds_neighbors(0, 0).should eq([[1, 0], [1, 1], [0, 1]])
    end
  end

  describe "#living_neighbors" do
    it "returns an array of neighbors that are alive" do
      gol = GameOfLife.new(5, 5, [[2, 1], [2, 2], [2, 3]], :standard)
      gol.living_neighbors(2, 2).should eq([[2, 1], [2, 3]])
      gol.living_neighbors(2, 1).should eq([[2, 2]])
      gol.living_neighbors(0, 0).should eq([])
    end
  end

  describe "#next_cell_state" do
    it "returns the next state of the given cell, :alive or :dead" do
      gol = GameOfLife.new(5, 5, [[2, 1], [2, 2], [2, 3]], :standard)
      gol.next_cell_state(0, 0).should eq(:dead)
      gol.next_cell_state(2, 2).should eq(:alive)
      gol.next_cell_state(2, 1).should eq(:dead)
      gol.next_cell_state(1, 2).should eq(:alive)
      gol.next_cell_state(2, 3).should eq(:dead)
      gol.next_cell_state(3, 2).should eq(:alive)
    end
  end

  describe "#run_generation" do
    it "runs one iteration of the world and updates the state" do
      gol = GameOfLife.new(5, 5, [[2, 1], [2, 2], [2, 3]], :standard)
      gol.run_generation
      (0...5).each do |x|
        (0...5).each do |y|
          if y == 2 and (x == 1 or x == 2 or x == 3)
            gol.status(x, y).should eq(:alive)
          else
            gol.status(x, y).should eq(:dead)
          end
        end
      end
    end
  end
end
