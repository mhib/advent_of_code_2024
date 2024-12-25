@list = nil
File.readlines('in.txt', chomp: true).each do |line|
  @list = line.split(" ").map(&:to_i)
end

def part1
  list = @list
  25.times do
    new_list = []
    list.each do |x|
      if x == 0
        new_list << 1
        next
      end
      str = x.to_s
      if str.size.even?
        new_list << str[0...(str.size / 2)].to_i
        new_list << str[(str.size / 2)..-1].to_i
        next
      end
      new_list << x * 2024
    end
    list = new_list
  end 
  list.size
end

def part2
  mem = {}
  calc = lambda do |x, depth|
    return 1 if depth == 0
    key = [x, depth]
    if (val = mem[key])
      return val
    end
    return mem[key] = calc[1, depth - 1] if x == 0
    str = x.to_s
    if str.size.even?
      return mem[key] = [
        str[0...(str.size / 2)].to_i,
        str[(str.size / 2)..-1].to_i
    ].sum { |c| calc[c, depth - 1] }
    end
    mem[key] = calc[x * 2024, depth - 1]
  end
  @list.sum { |c| calc[c, 75] }
end

p part1
p part2