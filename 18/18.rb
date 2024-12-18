LEN = 71
WID = 71

@obstacles = File.readlines('in.txt', chomp: true).map { |l| l.split(",").map(&:to_i) }

NEIS = [
  [0, -1],
  [0, 1],
  [-1, 0],
  [1, 0],
]

def part1
  obstacles = Set.new

  @obstacles.each_with_index do |(x, y), i|
    break if i >= 1024
    obstacles << [y, x]
  end
  q = [[0, 0]]
  visited = Set.new(q)

  steps = 1
  while q.any?
    q.size.times do
      (y, x) = q.shift

      NEIS.each do |dy, dx|
        ny = y + dy
        nx = x + dx
        next if ny < 0 || ny >= LEN
        next if nx < 0 || nx >= WID
        return steps if ny == LEN - 1 && nx == WID - 1
        key = [ny, nx]
        next if obstacles.include?(key)
        next unless visited.add?(key)
        q << key
      end
    end
    steps += 1
  end
end

p part1

NEIS2 = [
  [-1, -1], [-1, +0], [-1, +1],
  [+0, -1],           [+0, +1],
  [+1, -1], [+1, +0], [+1, +1],
]

def part2
  sets_size = LEN * WID + 4

  north = LEN * WID
  west  = LEN * WID + 1
  south = LEN * WID + 2
  east  = LEN * WID + 3

  sets = (0...sets_size).to_a

  visited = Set.new

  find = lambda do |x|
    if sets[x] != x
      sets[x] = find[sets[x]]
    end
    sets[x]
  end

  union = lambda do |l, r|
    l = find[l]
    r = find[r]
    return if l == r
    sets[r] = l
  end

  to_id = lambda do |y, x|
    y * WID + x
  end

  @obstacles.each do |x, y|
    visited << [y, x]
    id = to_id[y, x]
    if y == 0
      union[north, id]
    end

    if y == LEN - 1
      union[south, id]
    end

    if x == 0
      union[west, id]
    end

    if x == WID - 1
      union[east, id]
    end

    NEIS2.each do |dy, dx|
      ny = y + dy
      nx = x + dx
      next if ny < 0 || ny >= LEN
      next if nx < 0 || nx >= LEN
      next unless visited.include?([ny, nx])
      union[to_id[ny, nx], id]
    end

    if find[north] == find[south] || find[west] == find[north] || find[west] == find[east]
      return "#{x},#{y}"
    end
  end

end

p part2