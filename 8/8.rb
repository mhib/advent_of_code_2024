@antennas = {}
@len = 0
@wid = 0

File.readlines('in.txt', chomp: true).each_with_index do |line, y|
  @wid = line.size
  line.each_char.with_index do |char, x|
    next if char == '.'
    @antennas[char] ||= []
    @antennas[char] << [y, x]
  end
  @len += 1
end

def part_1
  visited = Set.new
  add_point = lambda do |y, x|
    return if y < 0 || y >= @len
    return if x < 0 || x >= @wid
    visited << [y, x]
  end
  @antennas.each do |k, list|
    list.combination(2) do |(ly, lx), (ry, rx)|
      diff_y = ly - ry
      diff_x = lx - rx
      add_point[ly + diff_y, lx + diff_x]
      add_point[ry - diff_y, rx - diff_x]
    end
  end
  visited.size
end

def part_2
  visited = Set.new
  move = lambda do |y, x, delta_y, delta_x|
    tmp_visited = Set.new
      while y >= 0 && y < @len && x >= 0 && x < @wid && tmp_visited.add?([y, x])
        visited << [y, x]
        y += delta_y
        x += delta_x
      end
  end
  @antennas.each do |k, list|
    list.combination(2) do |(ly, lx), (ry, rx)|
      diff_y = ly - ry
      diff_x = lx - rx
      move[ly, lx, diff_y, diff_x]
      move[ry, rx, -diff_y, -diff_x]
    end
  end
  visited.size
end


p part_1
p part_2