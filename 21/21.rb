@input = File.readlines('in.txt', chomp: true).to_a

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

NUMERIC_PAD = {
  '7' => Point.new(0, 0),
  '8' => Point.new(0, 1),
  '9' => Point.new(0, 2),
  '4' => Point.new(1, 0),
  '5' => Point.new(1, 1),
  '6' => Point.new(1, 2),
  '1' => Point.new(2, 0),
  '2' => Point.new(2, 1),
  '3' => Point.new(2, 2),
  '0' => Point.new(3, 1),
  'A' => Point.new(3, 2),
}.freeze

NUMERIC_INVERT = NUMERIC_PAD.invert.freeze

ARROW_PAD = {
  '^' => Point.new(0, 1),
  'A' => Point.new(0, 2),
  '<' => Point.new(1, 0),
  'v' => Point.new(1, 1),
  '>' => Point.new(1, 2),
}.freeze
ARROW_INVERT = ARROW_PAD.invert.freeze

DIRS = {
  '^' => Point.new(-1, 0),
  'v' => Point.new(1, 0),
  '<' => Point.new(0, -1),
  '>' => Point.new(0, 1),
}.freeze

class CostMemo
  def initialize
    @get_memo = {}
    @numeric_moves_memo = {}
    @arrow_moves_memo = {}
  end

  def get(bot_idx, char, dest_char, bot_count)
    key = [bot_idx, char, dest_char, bot_count]
    if (val = @get_memo[key]) != nil
      return val
    end

    return 1 if char == dest_char

    if bot_idx == bot_count - 1
      pad = bot_idx.zero? ? NUMERIC_PAD : ARROW_PAD
      return (pad[char] - pad[dest_char]).size + 1
    end

    min = 1.0 / 0
    (bot_idx == 0 ? get_numeric_moves(char, dest_char) : get_arrow_moves(char, dest_char)).each do |perm|
      cost = 0
      perm.each_with_index do |key, idx|
        cost += get(bot_idx + 1, idx.zero? ? 'A' : perm[idx - 1], key, bot_count)
      end
      cost += get(bot_idx + 1, perm[-1], 'A', bot_count)

      min = [min, cost].min
    end
    @get_memo[key] = min
  end

  def get_numeric_moves(from, to)
    @numeric_moves_memo[[from, to]] ||= calculate_move(NUMERIC_PAD[from], NUMERIC_PAD[to], &NUMERIC_INVERT)
  end

  def get_arrow_moves(from, to)
    @arrow_moves_memo[[from, to]] ||= calculate_move(ARROW_PAD[from], ARROW_PAD[to], &ARROW_INVERT)
  end

  def calculate_move(from, to)
    diff = to - from

    arr = []

    arr.concat(['<'] * -diff.x) if diff.x < 0
    arr.concat(['>'] * diff.x) if diff.x > 0

    arr.concat(['^'] * -diff.y) if diff.y < 0
    arr.concat(['v'] * diff.y) if diff.y > 0

    arr.permutation.uniq.filter do |perm|
      current = from
      perm.all? do |c|
        current += DIRS[c]
        yield(current)
      end
    end
  end
end

@memo = CostMemo.new

def get_sequence_cost(seq, robots)
  cost = @memo.get(0, 'A', seq[0], robots)
  1.upto(seq.size - 1) do |idx|
    cost += @memo.get(0, seq[idx - 1], seq[idx], robots)
  end
  cost
end

def part1
  @input.sum do |seq|
    get_sequence_cost(seq, 3) * seq.to_i
  end
end

def part2
  @input.sum do |seq|
    get_sequence_cost(seq, 26) * seq.to_i
  end
end

p part1
p part2