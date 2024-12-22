@input = File.readlines('in.txt', chomp: true).map(&:to_i)
PRUNE_MASK = ((1 << 24) - 1)

def next_val(secret)
  secret = (secret ^ (secret << 6)) & PRUNE_MASK
  secret = (secret ^ (secret >> 5)) # Pruning not needed
  (secret ^ (secret << 11)) & PRUNE_MASK
end


def part1
  @input.sum do |l|
    2000.times do
      l = next_val(l)
    end
    l
  end
end


def part2
  hash_mask = ((1 << 20) - 1)
  seq_sum = Hash.new(0)
  @input.each do |l|
    seen = Set.new
    prev = l % 10
    hash = 0
    2000.times do |i|
      l = next_val(l)
      current = l % 10
      diff = current - prev
      prev = current
      hash <<= 5
      hash |= (diff + 10)
      hash &= hash_mask

      if i > 2 && seen.add?(hash)
        seq_sum[hash] += current
      end
    end
  end
  seq_sum.each_value.max
end

p part1
p part2