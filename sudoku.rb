class Sudoku
  SIZE = 3
  END_INDEX = SIZE * SIZE - 1

  attr_reader :board

  def initialize(board_str)
    @board = Array.new(SIZE * SIZE) { Array.new(SIZE * SIZE) {[]} }
    cells = board_str.split('')

    each_coord do |row, col|
      @board[row][col] = Cell.new(cells.shift.to_i, row, col, @board)
    end
  end

  def solved?
    s = @board.flatten.select(&:solved?).size == SIZE ** 4
    puts "SOLVED BOARD" if s
    s
  end

  def unsolved_cells
    @board.flatten.select {|c| !c.solved?}
  end

  def solve!
    constrain!
    solve_recursive!(0)
  end

  def solve_recursive!(level)
    return true if solved?
    cell = unsolved_cells.first
    puts "#{level} Found #{cell.to_debug_s}"

    cell.open.any? do |num|
      cell.try!(num) do
        break true if solved?
        break false if any_broken?
        solve_recursive!(level+1)
      end
    end
  end

  def constrain!
    until (unused_cells = usable_cells).empty?
      unused_cells.each do |cell|
        cell.mark_affected(@board)
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

  def any_broken?
    b = @board.flatten.any?(&:broken?)
    puts "BROKEN BOARD" if b
    b
  end
end

class Cell
  attr_reader :num
  attr_accessor :used, :open

  def initialize(num, row, col, board)
    @row, @col = row, col
    @board = board
    @num = num == 0 ? nil : num
    @open = @num ? [] : (1..9).to_a
    @used = false
  end

  def try!(guess)
    puts "Trying #{guess} on #{self.to_debug_s}"
    @open.delete(guess)
    @num = guess
    affected_coords.each do |row, col|
      @board[row][col].mark!(@num)
    end

    val = yield

    affected_coords.each do |row, col|
      @board[row][col].unmark!(@num)
    end

    val
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

  def unmark!(n)
    @open.push(n)
  end

  def mark!(n)
    @open.delete(n)
  end

  def mark_and_set!(n)
    mark!(n)
    @num = @open.pop if @open.size == 1
  end

  def mark_affected(board)
    affected_coords.each do |row, col|
      board[row][col].mark_and_set!(@num)
    end
    @used = true
  end

  def usable?
    !@used && @num
  end

  def solved?
    !! @num
  end

  def broken?
    !@num && @open.empty?
  end

  def to_s
    @num ? @num.to_s : '-'
  end

  def to_debug_s
    "#{@row},#{@col} open: #{@open}"
  end
end