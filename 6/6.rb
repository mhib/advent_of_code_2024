DIRECTIONS = [
  [-1, 0],
  [0, 1],
  [1, 0],
  [0, -1],
].map(&:freeze).freeze

@start = nil

@map = []

File.readlines('in.txt', chomp: true).each_with_index do |line, y|
  line.each_char.with_index do |char, x|
    if char == '^'
      @start = [y, x]
    end
  end
  @map << line.dup
end

def part_1
  y, x = @start
  visited = Set[@start]
  len = @map.size
  wid = @map[0].size

  dir_idx = 0
  while true
    moved = false
    next_y = y + DIRECTIONS[dir_idx][0]
    next_x = x + DIRECTIONS[dir_idx][1]
    return visited if next_y >= len || next_y < 0 || next_x >= wid || next_x < 0
    if @map[next_y][next_x] == '#'
      dir_idx += 1
      dir_idx %= DIRECTIONS.size
      next_y = y
      next_x = x
    end
    y = next_y
    x = next_x
    visited << [next_y, next_x]
  end
end

path = part_1
p path.size

def is_looped?
  y, x = @start
  dir_idx = 0
  visited = Set[[*@start, dir_idx]]
  len = @map.size
  wid = @map[0].size

  while true
    moved = false
    next_y = y + DIRECTIONS[dir_idx][0]
    next_x = x + DIRECTIONS[dir_idx][1]
    if next_y >= len || next_y < 0  
      return false
    end
    if next_x >= wid || next_x < 0  
      return false
    end
    if @map[next_y][next_x] == '#'
      dir_idx += 1
      dir_idx %= DIRECTIONS.size
      next_y = y
      next_x = x
    end
    y = next_y
    x = next_x
    return true unless visited.add?([y, x, dir_idx])
  end
  false
end

def part_2(path)
  path.count do |y, x|
    char = @map[y][x]
    next if char == '^'
    @map[y][x] = '#'
    val = is_looped?
    @map[y][x] = char
    val
  end 
end

p part_2(path)
