
@data = File.readlines('in.txt', chomp: true).map { _1.split(/\s+/).map(&:to_i) }

def part_1(data)
  left = data.map(&:first).tap(&:sort!)
  right = data.map(&:last).tap(&:sort!)

  left.zip(right).reduce(0) do |sum, (l, r)|
    sum + (l - r).abs
  end
end

def part_2(data)
  left = data.map(&:first)
  right_counts = data.map(&:last).tally

  left.reduce(0) do |m, e|
    m + e * (right_counts[e] || 0)
  end
end

p part_1(@data)
p part_2(@data)