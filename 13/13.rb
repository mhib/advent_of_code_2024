require 'matrix'
Question = Struct.new(:a, :b, :target)
@questions = File.readlines('in.txt', chomp: true).each_slice(4).map do |first, second, prize, _|
    Question.new(
        first.scan(/\+(\d+)/).map(&:first).map(&:to_i),
        second.scan(/\+(\d+)/).map(&:first).map(&:to_i),
        prize.scan(/=(\d+)/).map(&:first).map(&:to_i)
    )
end

def part1
    @questions.sum do |q|
        res = Matrix[[q.a[0], q.b[0]], [q.a[1], q.b[1]]].inv * Vector[*q.target]
        next 0 unless res.all? { |x| x == x.to_i }
        (res[0] * 3 + res[1]).to_i
    end
end

def part2
    add = proc { |x| x + 10000000000000 }
    @questions.sum do |q|
        res = Matrix[
            [q.a[0], q.b[0]],
            [q.a[1], q.b[1]]
        ].inv * Vector[*q.target.map(&add)]
        next 0 unless res.all? { |x| x == x.to_i }
        (res[0] * 3 + res[1]).to_i
    end
end
p part1
p part2