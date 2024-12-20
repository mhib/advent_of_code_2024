@patterns = nil
@designs = []

reading_patterns = true

File.readlines('in.txt', chomp: true).each do |line|
  if line.empty?
    reading_patterns = false
    next
  end
  if reading_patterns
    @patterns = line.split(', ').group_by { |c| c[0] }
  else
    @designs << line
  end
end

def is_possible?(design)
  memo = Array.new(design.size)

  dfs = lambda do |idx|
    return true if idx >= design.size

    if (val = memo[idx]) != nil
      return val
    end

    memo[idx] = (@patterns[design[idx]] || []).any? do |pattern|
      suffix = design[idx, pattern.size]
      suffix == pattern && dfs[idx + pattern.size]
    end
  end
  dfs[0]
end

def part_1
  @designs.count { is_possible?(_1) }
end

def count_possibilities(design)
  memo = Array.new(design.size)

  dfs = lambda do |idx|
    return 1 if idx >= design.size

    if (val = memo[idx]) != nil
      return val
    end

    memo[idx] = (@patterns[design[idx]] || []).sum do |pattern|
      suffix = design[idx, pattern.size]
      suffix == pattern ? dfs[idx + pattern.size] : 0
    end
  end
  dfs[0]
end

def part_2
  @designs.sum { count_possibilities(_1) }
end


p part_1
p part_2