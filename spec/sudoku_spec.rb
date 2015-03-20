require_relative '../sudoku'

describe Sudoku do
  EASY_BOARD = '---26-7-168--7--9-19---45--82-1---4---46-29---5---3-28--93---74-4--5--367-3-18---'
  SOLVED_BOARD = '435269781682571493197834562826195347374682915951743628519326874248957136763418259'

  let(:easy_board) { Sudoku.new(EASY_BOARD) }
  let(:solved_board) { Sudoku.new(SOLVED_BOARD) }

  it "should read input boards" do
    expect(easy_board.to_compact_s).to eq(EASY_BOARD)
  end

  it "should identify solved boards" do
    expect(solved_board.solved?).to eq(true)
  end

  it "should solve easy boards" do
    easy_board.solve!
    expect(easy_board.solved?).to eq(true)
  end

  it "should solve hard boards" do

  end
end