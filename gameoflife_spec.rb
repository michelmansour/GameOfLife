require_relative 'gameoflife'

describe GameOfLife, "#out_of_bounds?" do
  it "returns true if x < 0" do
    gol = GameOfLife.new(1,1,[])
    gol.out_of_bounds?(-1,0).should eq(true)
  end
end
