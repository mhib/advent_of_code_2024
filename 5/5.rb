@before = []
@after = []

edges_input = true

@queries = []

File.readlines('in.txt', chomp: true).each do |line|
  if line.empty?
    edges_input = false
    next
  end
  if edges_input
    l, r = line.split("|").map(&:to_i)
    @before[r] ||= Set.new
    @before[r] << l

    @after[l] ||= Set.new
    @after[l] << r
  else
    @queries << line.split(",").map(&:to_i)
  end
end

def is_query_valid?(query)
  invalid = Set.new

  query.each do |el|
    return false if invalid.include?(el)
    invalid.merge(@before[el] || [])
  end
  true
end

def part_1
  sum = 0
  @queries.map do |query|
    sum += query[query.size / 2] if is_query_valid?(query)
  end
  sum
end

def order_query(query)
  els = Set.new(query)

  in_count = Hash.new(0)

  query.each do |el|
    (@after[el] || []).each do |nei|
      next unless els.include?(nei)
      in_count[nei] += 1
    end
  end

  q = query.select { |x| in_count[x] == 0 }
  res = []
  while q.any?
    el = q.pop
    res << el

    (@after[el] || []).each do |nei|
      next unless els.include?(nei)
      tmp = (in_count[nei] -= 1)
      q << nei if tmp == 0
    end
  end
  res
end

def part_2
  sum = 0
  @queries.map do |query|
    next if is_query_valid?(query)
    ordered = order_query(query)
    sum += ordered[ordered.size / 2]
  end
  sum
end

p part_1
p part_2
