
@map = []
@starts = []
File.readlines('in.txt', chomp: true).each_with_index do |line, y|
  line = line.each_char.map(&:to_i)
  @map << line
  line.each_with_index do |val, x|
    if val == 0
      @starts << [y, x]
    end
  end
end

NEIS = [
  [0, -1],
  [0, 1],
  [-1, 0],
  [1, 0]
].map(&:freeze).freeze

def part1
  len = @map.size
  wid = @map[0].size

  visit = lambda do |y, x, visited_nines|
    current_val = @map[y][x]
    if current_val == 9
      visited_nines << [y, x]
      return visited_nines
    end

    NEIS.each do |delta_y, delta_x|
      new_y = y + delta_y
      new_x = x + delta_x
      next if new_y < 0 || new_y >= len || new_x < 0 || new_x >= wid
      next if @map[new_y][new_x] != current_val + 1
      visit[new_y, new_x, visited_nines]
    end
    return visited_nines
  end

  @starts.sum do |y, x|
    visit[y, x, Set.new].size
  end
end

def part2
  len = @map.size
  wid = @map[0].size

  visit = lambda do |y, x|
    current_val = @map[y][x]
    if current_val == 9
      return 1
    end

    local_sum = 0

    NEIS.each do |delta_y, delta_x|
      new_y = y + delta_y
      new_x = x + delta_x
      next if new_y < 0 || new_y >= len || new_x < 0 || new_x >= wid
      next if @map[new_y][new_x] != current_val + 1
      local_sum += visit[new_y, new_x]
    end
    local_sum
  end

  @starts.sum do |y, x|
    visit[y, x]
  end
end

p part1
p part2