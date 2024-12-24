
@initial_values = {}
@rules = []

reading_initial = true

Rule = Struct.new(:inputs, :op, :output)

OP_MAP = {
'AND' => :&,
'OR' => :|,
'XOR' => :^,
}.freeze

File.readlines('in.txt', chomp: true).each do |l|
  if l.empty?
    reading_initial = false
    next
  end
  
  if reading_initial
    name, value = l.split(":")
    @initial_values[name] = value.to_i
  else
    l, op, r, out = l.scan(/(\S+) (\S+) (\S+) -> (\S+)/)[0]
    @rules << Rule.new(Set[l, r], OP_MAP[op], out)
  end
end

def part1
  calculated_values = @initial_values.dup
  
  in_count = Hash.new(0)
  parents = Hash.new { |h, k| h[k] = [] }
  
  @rules.each do |rule|
    in_count[rule.output] += 2
    rule.inputs.each do |i|
      parents[i] << rule
    end
  end
  
  q = []
  
  calculated_values.each do |k, v|
    parents[k].each do |rule|
      in_count[rule.output] -= 1
      if in_count[rule.output] == 0
        q << rule
      end
    end
  end
  
  while q.any?
    el = q.shift
    calculated_values[el.output] = el.inputs.map(&calculated_values).reduce(el.op)
    parents[el.output].each do |parent|
      tmp = (in_count[parent.output] -= 1)
      if tmp == 0
        q << parent
      end
    end
  end
  p calculated_values.filter { |k, v| k[0] == 'z'}
  calculated_values.filter { |k, v| k[0] == 'z'}.sort.reverse.map(&:last).join("").to_i(2)
end

def generate_pairings(arr)
  return [] if arr.empty?
  return [[arr]] if arr.size == 2
  arr = arr.dup
  first = arr.shift
  
  res = []
  0.upto(arr.size - 1) do |x|
    tmp = arr.dup
    el = tmp.delete_at(x)
    pair = [first, el]
    generate_pairings(tmp).each do |rec|
      res << [pair, *rec]
    end
  end
  res
end

# This is not a general algorithm bot works for the inputs
def part2
  prev_carry = @rules.find { |c| c.inputs == Set['x00', 'y00'] && c.op == :& }.output

  max_num = 0
  max_path = []
  candidates = Set[]

  1.upto(44) do |num|
      id = num.to_s.rjust(2, '0')
      
      y = 'y' + id
      x = 'x' + id
      z = 'z' + ((num).to_s.rjust(2, '0'))
      current_sum = @rules.find { |c| c.inputs == Set[x, y] && c.op == :^ }.output
      # p [num, current_sum]
      res_sum = @rules.find { |c| c.output == z && c.op == :^ }
      candidate_sum = @rules.find { |c| c.inputs == Set[current_sum, prev_carry] && c.op == :^ }
      if candidate_sum.nil?
        candidates += (res_sum.inputs ^ Set[current_sum, prev_carry])
      end
      # p [num, res_sum]
      current_carry = @rules.find { |c| c.inputs == Set[x, y] && c.op == :& }.output
      # p [num, current_carry]
      sum_carry = @rules.find { |c| c.inputs == Set[current_sum, prev_carry] && c.op == :& }
      if sum_carry.nil?
        sum_carry = @rules.find { |c| (c.inputs & Set[current_sum, prev_carry]).any? && c.op == :& } 
        candidates += (sum_carry.inputs ^ Set[current_sum, prev_carry])
      end
      sum_carry = sum_carry.output
      # p [num, sum_carry]
      new_carry = @rules.find { |c| c.inputs == Set[current_carry, sum_carry] && c.op == :| }
      if new_carry.nil?
        new_carry = @rules.find { |c| (c.inputs & Set[current_carry, sum_carry]).any? && c.op == :| }
        candidates += (new_carry.inputs ^ Set[current_carry, sum_carry])
      end
      prev_carry = new_carry.output
  end
  candidates.sort.join(",")
end

# p part1
p part2