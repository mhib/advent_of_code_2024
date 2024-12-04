
FIRST_NEIS = [
  [[0, -1], [0, -2], [0, -3]],
  [[0, 1], [0, 2], [0, 3]],
  [[1, 0], [2, 0], [3, 0]],
  [[-1, 0], [-2, 0], [-3, 0]],
  [[1, 1], [2, 2], [3, 3]],
  [[-1, 1], [-2, 2], [-3, 3]],
  [[1, -1], [2, -2], [3, -3]],
  [[-1, -1], [-2, -2], [-3, -3]],
].map(&:freeze).freeze

@input = File.readlines('in.txt', chomp: true)


FIRST_REST = ['M', 'A', 'S'].freeze
def count_xmas(input, length, width, y, x)
  FIRST_NEIS.count do |list|
    list.map do |delta_y, delta_x|
      new_y = y + delta_y
      break if new_y >= length || new_y < 0
      new_x = x + delta_x
      break if new_x >= width || new_x < 0
      input[new_y][new_x]
    end == FIRST_REST
  end
end

def part_1(input)
  length = input.size
  width = input[0].size
  sum = 0
  input.each_with_index do |line, y|
    line.each_char.with_index do |c, x|
      next if c != 'X'
      sum += count_xmas(input, length, width, y, x)
    end
  end
  sum
end

SECOND_NEIS = [
  [[-1, -1], [1, 1]],
  [[1, -1], [-1, 1]],
].map(&:freeze).freeze
SECOND_REST = %w[M S]

def is_x_mas?(input, length, width, y, x)
  SECOND_NEIS.all? do |list|
    found = list.map do |delta_y, delta_x|
      new_y = y + delta_y
      break if new_y >= length || new_y < 0
      new_x = x + delta_x
      break if new_x >= width || new_x < 0
      input[new_y][new_x]
    end
    found&.sort == SECOND_REST
  end
end

def part_2(input)
  length = input.size
  width = input[0].size
  sum = 0
  input.each_with_index do |line, y|
    line.each_char.with_index do |c, x|
      next if c != 'A'
      sum += 1 if is_x_mas?(input, length, width, y, x)
    end
  end
  sum
end

p part_1(@input)
p part_2(@input)