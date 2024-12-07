@lines = File.readlines('in.txt', chomp: true).map { |x| x.split(' ').map(&:to_i) }

def line_value_1(line)
  res, *operands = line
  operators_count = operands.size - 1
  0.upto((1 << operators_count) - 1).any? do |mask|
    acc = operands[0]

    1.upto(operands.size - 1) do |idx|
      number = operands[idx]
      if mask & (1 << (idx - 1)) == 0
        acc += number
      else
        acc *= number
      end
      break if acc > res
    end
    acc == res
  end ? res : 0
end

def part1
  @lines.sum { |l| line_value_1(l) }
end

def decimal_log(num)
  return 1 if num == 0
  len = 0
  while num > 0
    len += 1
    num /= 10
  end
  len
end

def line_value_2(line)
  res, *operands = line
  operands_size = operands.size
  dfs = lambda do |idx, acc|
    return acc == res if idx >= operands_size
    return false if acc > res
    return true if dfs[idx + 1, acc + operands[idx]]
    return true if dfs[idx + 1, acc * operands[idx]]
    return true if dfs[idx + 1, acc * (10 ** decimal_log(operands[idx])) + operands[idx]]
    false
  end
  dfs[1, operands[0]] ? res : 0
end

def part2
  @lines.sum { |l| line_value_2(l) }
end

p part1
p part2