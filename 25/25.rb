@locks = []
@keys = []


current = []
parse_current = lambda do
  if current[0].each_char.all? { |c| c == '#'} # lock
    lock = (0...current[0].size).map do |x|
      (1..current.size - 1).bsearch { |y| current[y][x] == '.' } - 1
    end
    @locks << lock
  else
    key = (0...current[0].size).map do |x|
      current.size - (1..current.size - 1).bsearch { |y| current[y][x] == '#' } - 1
    end
    @keys << key
  end
end
File.readlines('in.txt', chomp: true).each do |line|
  if line.empty?
    parse_current[]
    current = []
    next
  end
  current << line
end
if current.any?
  parse_current[]
  current = nil
end

def part1
  @locks.sum do |lock|
    @keys.count do |key|
      lock.each_with_index.all? { |l, i| l + key[i] <= 5 }
    end
  end
end

p part1