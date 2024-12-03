@data = File.readlines('in.txt', chomp: true).map { |line| line.split(/\s+/).map(&:to_i) }

RANGE = (1..3)

def is_save_1?(arr)
  predicate = proc { |l, r| l > r && RANGE.cover?(l - r) }
  arr.each_cons(2).all?(&predicate) ||
    arr.each_cons(2).all? { |l, r| predicate[r, l] }
end


def is_save_2?(arr)
  return true if is_save_1?(arr)
  arr.each_index.any? do |idx|
    is_save_1?(arr.dup.tap { _1.delete_at(idx) })
  end
end

p @data.count { |x| is_save_1?(x) }
p @data.count { |x| is_save_2?(x) }