require 'optparse'
require_relative 'gameoflife'

width = 5
height = 5
live_cells = [[1,2], [2,2], [3,2]]
border_rule = :standard

OptionParser.new do |o|
  o.banner = "Usage: gameoflife.rb [options]"
  o.on('-d N,M', Array, "Width and height of the world") { |d| width = d[0].to_i; height = d[1].to_i; live_cells = [] }
  o.on('-a X1,Y1,X2,Y2,...', Array, "Living cells as coordinate pairs") do |a|
    if not a.length.even?
      print "Error: Must specify living cells as pairs"
      exit
    end
    live_cells = a.collect { |k| k.to_i }.each_slice(2).to_a
  end
  o.on('-b <standard|torus>', "Border rule: standard (default) or torus") do |b|
    if b.downcase == "torus"
      border_rule = :torus
    end
  end
  o.on_tail("-h", "--help", "Show this message") do
    puts o
    exit
  end
end.parse!

GameOfLife.new(width, height, live_cells, border_rule).run
