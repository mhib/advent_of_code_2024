NEIS = [
  [0, -1],
  [0, 1],
  [-1, 0],
  [1, 0],
]

@start = nil
@stop = nil
@board = []

File.readlines('in.txt', chomp: true).each_with_index do |line, y|
  line.each_char.with_index do |c, x|
    if c == 'S'
      @start = [y, x]
    elsif c == 'E'
      @stop = [y, x]
    end
  end
  @board << line
end

def get_distance
  len = @board.size
  wid = @board[0].size
  steps = 1

  q = [@stop]
  dists = Array.new(len) { Array.new(wid) }
  dists[@stop[0]][@stop[1]] = 0
  while q.any?
    q.size.times do
      y, x = q.shift

      NEIS.each do |dy, dx|
        ny = y + dy
        nx = x + dx

        next if @board[ny][nx] == '#'
        if ny == @start[0] && nx == @start[1]
          dists[ny][nx] = steps
          break
        end
        next if dists[ny][nx]
        dists[ny][nx] = steps
        q << [ny, nx]
      end
    end
    steps += 1
  end

  dists
end

def generate_deltas(upto)
  res = [NEIS]
  seen = Set.new(NEIS)
  (upto - 1).times do
    tmp = []
    res.last.each do |y, x|
      NEIS.each do |dy, dx|
        ny = y + dy
        nx = x + dx
        key = [ny, nx]
        next unless seen.add?([ny, nx])
        tmp << key
      end
    end
    res << tmp
  end
  res
end

def with_cheating_of_at_most_cheats(cheats, saved)
  len = @board.size
  wid = @board[0].size

  dists = get_distance
  start_dist = dists[@start[0]][@start[1]]

  q = [@start]
  visited = Array.new(len) { Array.new(wid) }
  visited[@start[0]][@start[1]] = true
  steps = 0

  deltas = generate_deltas(cheats)

  count = 0

  while steps <= start_dist - saved
    q.size.times do
      y, x = q.shift

      1.upto(deltas.size - 1) do |delta_idx|
        cost = delta_idx + 1
        break if steps + cost > start_dist - saved
        deltas[delta_idx].each do |dy, dx|
          ny = y + dy
          nx = x + dx

          next if ny < 0 || ny >= len
          next if nx < 0 || nx >= wid
          if (dists[ny][nx] || 1.0 / 0) + steps + cost <= start_dist - saved
            count += 1
          end
        end
      end

      NEIS.each do |dy, dx|
        ny = y + dy
        nx = x + dx

        next if @board[ny][nx] == '#'
        next if visited[ny][nx]
        visited[ny][nx] = true
        q << [ny, nx]
      end
    end
    steps += 1
  end
  count
end

def part1
  with_cheating_of_at_most_cheats(2, 100)
end

def part2
  with_cheating_of_at_most_cheats(20, 100)
end

p part1
p part2