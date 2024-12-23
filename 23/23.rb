@input = File.readlines('in.txt', chomp: true).map { |l| l.split("-") }

def part1
  computers = @input.flatten.uniq.sort

  neis = Hash.new { |h, k| h[k] = [] }
  @input.each do |l, r|
    if r < l
      l, r = r, l
    end
    neis[l] << r
  end

  count = 0

  computers.each do |l|
    neis[l].each do |r|
      common = neis[l] & neis[r]
      if l[0] == 't' || r[0] == 't'
        count += (common).size
      else
        count += common.count { |t| t[0] == 't' }
      end
    end
  end

  count
end

EMPTY_SET = Set.new.freeze
def bron_kerbosch(r, p, x, neis)
  return r if p.empty? && x.empty?

  max = EMPTY_SET
  pivot = p.first || x.first
  (p - (neis[pivot] || Set.new)).each do |v|
    rec = bron_kerbosch(
      r + Set[v],
      p & neis[v],
      x & neis[v],
      neis
    )
    if rec.size > max.size
      max = rec
    end
    p.delete(v)
    x.add(v)
  end
  max
end

def largest_clique(neis)
  bron_kerbosch(Set[], Set.new(neis.each_key), Set[], neis)
end

def part2
  neis = Hash.new { |h, k| h[k] = Set.new }
  @input.each do |l, r|
    neis[l] << r
    neis[r] << l
  end

  largest_clique(neis).sort.join(",")
end
p part1
p part2