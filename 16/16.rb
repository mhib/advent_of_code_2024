require 'pairing_heap'

@board = []
@start = nil
@dest = nil 

File.readlines('in.txt', chomp: true).each_with_index do |row, y|
  @board << row.each_char.map.with_index do |c, x|
    next c if c == '.' || c == '#'
    if c == 'S'
      @start = [y, x]
    elsif c == 'E'
      @dest = [y, x]
    end
    '.'
  end
end

DELTAS = [
  [0, 1],
  [-1, 0],
  [0, -1],
  [1, 0]
]

def dijkstra(source)
  dists = {}

  current = source
  dists[current] = 0
  heap = PairingHeap::SimplePairingHeap.new
  heap.push(current, 0)

  while heap.any?
    current, dist = heap.pop_with_priority
    next if dist != dists[current]
    return [dists, dist] if yield(current)
    pos, dir = current

    rotate_dist = dist + 1000

    [1, -1].each do |dir_delta|
      new_dir = (dir + dir_delta) % 4
      key = [pos, new_dir]
      prev_val = dists[key]
      if prev_val.nil? || prev_val > rotate_dist
        dists[key] = rotate_dist
        heap.push(key, rotate_dist)
      end
    end

    y, x = pos
    y += DELTAS[dir][0]
    x += DELTAS[dir][1]
    new_dist = dist + 1
    if @board[y][x] == '.'
      key = [[y, x], dir]
      prev_val = dists[key]
      if prev_val.nil? || prev_val > new_dist
        dists[key] = new_dist
        heap.push(key, new_dist)
      end
    end
  end
  false
end

def part1
  dijkstra([@start, 0]) { |e| e[0] == @dest }[1]
end

p part1

def part2
  dists1, dist = dijkstra([@start, 0]) { |e| e[0] == @dest }
  dists1.filter! { |k, v| v <= dist }

  visited = Set[@start, @dest]

  0.upto(3) do |dir|
    dists2, dist2 = dijkstra([@dest, dir]) { |e| e == [@start, 2] }
    next if dist2 != dist

    dists1.each do |k, v|
      next if visited.include?(k[0])
      next if v > dist
      new_k = [k[0], (k[1] + 2) % 4]
      if v + (dists2[new_k] || 1.0 / 0) == dist
        visited << k[0]
      end
    end
  end
  visited.size
end

p part2