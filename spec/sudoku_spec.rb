require_relative '../sudoku'

describe Sudoku do
  EASY_BOARD = '---26-7-168--7--9-19---45--82-1---4---46-29---5---3-28--93---74-4--5--367-3-18---'
  SOLVED_BOARD = '435269781682571493197834562826195347374682915951743628519326874248957136763418259'
  HARD_BOARD = '52---6---------7-13-----------4--8--6------5-----------418---------3--2---87-----'
  INVALID_BOARD = '525--6---------7-13-----------4--8--6------5-----------418---------3--2---87-----'

  let(:easy_board) { Sudoku.new(EASY_BOARD) }
  let(:solved_board) { Sudoku.new(SOLVED_BOARD) }
  let(:hard_board) { Sudoku.new(HARD_BOARD) }
  let(:invalid_board) { Sudoku.new(INVALID_BOARD) }

  it "should read input boards" do
    expect(easy_board.to_compact_s).to eq(EASY_BOARD.gsub('-','0'))
  end

  it "should handle valid sets" do
    expect(easy_board.valid_set?([1,2,3,4,5,6,7,0,0])).to eq(true)
    expect(easy_board.valid_set?([1,2,4,4,5,6,7,0,0])).to eq(false)
  end

  it "should identify valid boards" do
    expect(solved_board.valid?).to eq(true)
    expect(easy_board.valid?).to eq(true)
    expect(hard_board.valid?).to eq(true)
    expect(invalid_board.valid?).to eq(false)
  end

  it "should solve easy boards" do
    expect(easy_board.solve).to eq(true)
    puts easy_board
  end

  it "should solve hard boards" do
    expect(hard_board.solve).to eq(true)
    puts hard_board
    # expect(hard_board.solved?).to eq(true)
  end
end