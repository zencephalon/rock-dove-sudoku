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

  def column_set(col)
    (0..END_INDEX).map do |row|
      @board[row][col]
    end
  end

  def row_set(row)
    (0..END_INDEX).map do |col|
      @board[row][col]
    end
  end

  def square_set(r, c)
    row_c = r * SIZE
    col_c = c * SIZE
    (row_c..(row_c+2)).map do |row|
      (col_c..(col_c+2)).map do |col|
        @board[row][col]
      end
    end.flatten
  end

  def valid_set?(set)
    set_no_zero = remove_zero(set)
    set_no_zero.uniq == set_no_zero
  end

  def valid_columns?
    (0..END_INDEX).all? {|col| valid_set?(column_set(col))}
  end

  def valid_rows?
    (0..END_INDEX).all? {|row| valid_set?(row_set(row))}
  end

  def valid_squares?
    (0...SIZE).map do |row|
      (0...SIZE).map do |col|
        valid_set?(square_set(row, col))
      end
    end.flatten.all?
  end

  def valid?
    valid_columns? && valid_rows? && valid_squares?
  end

  def remove_zero(arr)
    arr.reject {|c| c == 0}
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