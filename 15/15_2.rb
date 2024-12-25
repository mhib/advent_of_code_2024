Point = Struct.new(:y, :x) do
  def +(other)
    Point.new(y + other.y, x + other.x)
  end

  def -(other)
    Point.new(y - other.y, x - other.x)
  end

  def size
    y.abs + x.abs
  end
end

DIRS = {
  '^' => Point.new(-1, 0),
  'v' => Point.new(1, 0),
  '<' => Point.new(0, -1),
  '>' => Point.new(0, 1),
}.freeze

MAPPING  = {'#' => '##', '.' => '..', 'O' => '[]', '@' => '@.' }.freeze
REGEX = Regexp.union(MAPPING.keys)

reading_board = true

@board = []
@moves = []
@pos = []

File.readlines('in.txt', chomp: true).each do |line|
  if line.empty?
    reading_board = false
    next
  end
  if reading_board
    @board << line.gsub(REGEX, MAPPING)
    if (x = @board[-1].index('@'))
      @pos = Point.new(@board.size - 1, x)
    end
  else
    line.each_char { |c| @moves << c }
  end
end

def part2
  board = @board
  pos = @pos
  move = lambda do |current, dir|
    prev = current
    current += dir
    return false if board[current[0]][current[1]] == '#'
    return false if board[current[0]][current[1]] == '[' && (!move[current + Point.new(0, 1), dir] || !move[current, dir])
    return false if board[current[0]][current[1]] == ']' && (!move[current + Point.new(0, -1), dir] || !move[current, dir])
    board[current[0]][current[1]], board[prev[0]][prev[1]] = board[prev[0]][prev[1]], board[current[0]][current[1]]
    true
  end
  @moves.each do |arrow|
    dir = DIRS[arrow]
    prev_grid = board.map(&:dup)

    if move[pos, dir]
      pos += dir
    else
      board = prev_grid
    end
  end

  sum = 0
  board.each_with_index do |row, y|
    row.each_char.with_index do |c, x|
      if c == '['
        sum += y * 100 + x
      end
    end
  end
  sum
end

p part2