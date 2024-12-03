REGEX_1 = /mul\((\d+),(\d+)\)/

@input = File.readlines('in.txt', chomp: true)

def part_1(input)
  sum = 0
  input.each do |line|
    line.scan(REGEX_1) do |l, r|
      sum += l.to_i * r.to_i
    end
  end
  sum
end

REGEX_2 = /(mul\((\d+),(\d+)\)|(do\(\))|(don't\(\)))/

def part_2(input)
  ignore = false
  sum = 0
  input.each do |line|
    line.scan(REGEX_2) do |match|
      if match[0] == "do()"
        ignore = false
      elsif match[0] == "don't()"
        ignore = true
      else
        next if ignore
        sum += match[1].to_i * match[2].to_i
      end
    end
  end
  sum
end

p part_1(@input)
p part_2(@input)