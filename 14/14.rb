WIDTH = 101
LEN = 103
class Robot
    attr_reader :x, :y
    def initialize(x, y, dx, dy)
        @x = x
        @y = y
        @dy = dy
        @dx = dx
    end

    def update!(steps = 1)
        @x += @dx * steps 
        @x %= WIDTH
        @y += @dy * steps 
        @y %= LEN
    end
end

class Quadrant
    def initialize(x_range, y_range)
        @x_range = x_range
        @y_range = y_range
    end

    def cover?(robot)
        @y_range.cover?(robot.y) && @x_range.cover?(robot.x)
    end
end

QUADRANTS = [
    Quadrant.new((0...(WIDTH / 2)), (0...(LEN / 2))),
    Quadrant.new(((WIDTH / 2 + 1)...WIDTH), (0...(LEN / 2))),
    Quadrant.new((0...(WIDTH / 2)), ((LEN / 2 + 1)...LEN)),
    Quadrant.new(((WIDTH / 2 + 1)...WIDTH), ((LEN / 2 + 1)...LEN)),
]

@robots = []
File.readlines('in.txt', chomp: true).each do |line|
    @robots << Robot.new(*line.scan(/(-?\d+)/).map { |c| c.first.to_i })
end

def part1
    robots = @robots.map(&:dup)
    robots.each { |x| x.update!(100) }
    QUADRANTS.map { |q| robots.count { q.cover?(_1) } }.reduce(&:*)
end

def heuristic(robots)
    exists = Array.new(WIDTH) { Array.new(LEN, false) }
    robots.each { |r| exists[r.x][r.y] = true }
    0.upto(WIDTH - 1).any? do |x|
        0.upto(LEN - 9).any? do |start_y|
            start_y.upto(start_y + 8).all? { |y| exists[x][y] }
        end
    end
end

def part2
    robots = @robots.map(&:dup)
    val = 1.upto(1.0 / 0) do |x|
        robots.each(&:update!)
        if heuristic(robots)
            break x
        end
        p x if x % 100 == 0
    end

    exists = Array.new(WIDTH) { Array.new(LEN, false) }
    robots.each { |r| exists[r.x][r.y] = true }
    0.upto(LEN - 1) do |y|
        0.upto(WIDTH - 1) do |x|
            print exists[x][y] ? "█" : " "
        end
        puts ""
    end
    val
end
p part1
p part2