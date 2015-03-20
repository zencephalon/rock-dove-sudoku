class Sudoku
  SIZE = 3
  END_INDEX = SIZE * SIZE - 1

  def initialize(board_str)
    @board = Array.new(SIZE * SIZE) { Array.new(SIZE * SIZE) {[]} }
    cells = board_str.split('')

    each_coord do |row, col|
      @board[row][col] = Cell.new(cells.shift.to_i, row, col)
    end
  end

  def constrain!
    until (unused_cells = usable_cells).empty?
      unused_cells.each do |cell|
        cell.affected_coords do |row, col|
          @board[row][col].mark(cell.num)
        end
      end
    end
  end

  def to_s
    @board.map {|row| row.map(&:to_s).join(" ")}.join("\n")
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

  def mark(n)
    @open.delete(n)
    @num = @open.pop if @open.size == 1
  end

  def usable?
    !@used && @num
  end

  def to_s
    @num ? @num.to_s : '-'
  end
end