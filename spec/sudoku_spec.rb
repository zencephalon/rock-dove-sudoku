require_relative '../sudoku'

describe Sudoku do
  EASY_BOARD = '---26-7-168--7--9-19---45--82-1---4---46-29---5---3-28--93---74-4--5--367-3-18---'

  it "should read input boards" do
    s = Sudoku.new(EASY_BOARD)
    expect(s.to_compact_s).to eq(EASY_BOARD)
  end
end