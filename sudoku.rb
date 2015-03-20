class Sudoku
  SIZE = 3
  END_INDEX = SIZE * SIZE - 1

  attr_reader :board

  def initialize(board_str)
    @board = Array.new(SIZE * SIZE) { Array.new(SIZE * SIZE) {[]} }
    cells = board_str.split('')

    each_coord do |row, col|
      @board[row][col] = cells.shift.to_i
    end
  end

  def to_s
    @board.map {|row| row.join(" ")}.join("\n")
  end

  def to_compact_s
    @board.map {|row| row.join("")}.join("")
  end

  def usable_cells
    @board.flatten.select(&:usable?)
  end

  def each_coord
    (0..END_INDEX).each do |row|
      (0..END_INDEX).each do |col|
        yield(row, col)
      end
    end
  end
end