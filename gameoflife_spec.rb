require_relative 'gameoflife'

describe GameOfLife do
  describe "#out_of_bounds?" do
    it "returns true if x < 0" do
      gol = GameOfLife.new(1,1,[])
      gol.out_of_bounds?(-1,0).should eq(true)
    end
  end

  describe "#status" do
    it "returns :alive when cells are alive and :dead when cells are dead" do
      gol = GameOfLife.new(2,2,[[0,0]])
      gol.status(0,0).should eq(:alive)
      gol.status(1,1).should eq(:dead)
    end
  end
end
