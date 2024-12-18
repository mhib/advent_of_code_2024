@registers = []
@commands = nil

parsing_registers = true

File.readlines('in.txt', chomp: true).each do |l|
  if l.empty?
    parsing_registers = false
    next
  end

  if parsing_registers
    @registers << l.scan(/(\d+)/).first.first.to_i
  else
    _, commands = l.split(" ")
    @commands = commands.split(",").map(&:to_i)
  end
end

def simulate(registers)
  literal_value = lambda do |x|
    if x <= 3
      return x
    end
    return registers[x - 4]
  end

  out = []
  command_idx = 0
  while true
    opcode = @commands[command_idx]
    break if opcode.nil?
    literal = @commands[command_idx + 1]
    break if literal.nil?
    combo = literal_value[literal]

    case opcode
    when 0
      registers[0] = registers[0] / (2 ** combo)
    when 1
      registers[1] = registers[1] ^ literal
    when 2
      registers[1] = combo & 0b111
    when 3
      if registers[0] != 0
        command_idx = literal
        next
      end
    when 4
      registers[1] = registers[1] ^ registers[2]
    when 5
      out << combo % 8
    when 6
      registers[1] = registers[0] / (2 ** combo)
    when 7
      registers[2] = registers[0] / (2 ** combo)
    end

    command_idx += 2
  end
  out
end

def part1
  simulate(@registers.dup).join(",")
end

def reg_a(val)
    regs = @registers.dup
    regs[0] = val
    simulate(regs)
end

# observation: 3-bit sequence sets one output value
def part2
  out_idx = @commands.size - 1

  dfs = lambda do |current_val, out_idx|
    return current_val if out_idx == -1
    tmp = current_val << 3
    0.upto(7).each do |x|
      val = reg_a(tmp + x)
      if val[0] == @commands[out_idx]
        rec = dfs[tmp + x, out_idx - 1]
        return rec if rec
      end
    end
    nil
  end

  val = dfs[0, @commands.size - 1]
  p [val, reg_a(val)]
  val
end

p part1

p part2