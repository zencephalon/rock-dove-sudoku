class Sudoku
  SIZE = 3
  END_INDEX = SIZE * SIZE - 1

  attr_reader :board

  def initialize(board_str)
    @board = Array.new(SIZE * SIZE) { Array.new(SIZE * SIZE) {[]} }
    cells = board_str.split('')

    each_coord do |row, col|
      @board[row][col] = Cell.new(cells.shift.to_i, row, col)
    end
  end

  def solved?
    @board.flatten.select(&:solved?).size == SIZE ** 4
  end

  def solve!
    constrain!
  end

  def constrain!
    until (unused_cells = usable_cells).empty?
      unused_cells.each do |cell|
        cell.affected_coords.each do |row, col|
          @board[row][col].mark(cell.num)
        end
        cell.used = true
      end
    end
  end

  def to_s
    @board.map {|row| row.map(&:to_s).join(" ")}.join("\n")
  end

  def to_compact_s
    @board.map {|row| row.map(&:to_s).join("")}.join("")
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

class Cell
  attr_reader :num
  attr_accessor :used

  def initialize(num, row, col)
    @row, @col = row, col
    @num = num == 0 ? nil : num
    @open = @num ? [] : (1..9).to_a
    @used = false
  end

  def column
    (0..8).map {|col| [@row, col]}
  end

  def row
    (0..8).map {|row| [row, @col]}
  end

  def square
    row_corner = (@row / 3) * 3
    col_corner = (@col / 3) * 3
    (row_corner..(row_corner + 2)).map do |row|
      (col_corner..(col_corner + 2)).map do |col|
        [row, col]
      end
    end.flatten(1)
  end

  def affected_coords
    column + row + square
  end

  def mark(n)
    @open.delete(n)
    @num = @open.pop if @open.size == 1
  end

  def usable?
    !@used && @num
  end

  def solved?
    !! @num
  end

  def to_s
    @num ? @num.to_s : '-'
  end
end