
NEIS = [
    [0, -1],
    [0, 1],
    [-1, 0],
    [1, 0],
].map(&:freeze).freeze

@map = File.readlines('in.txt', chomp: true).to_a
@len = @map.size
@wid = @map[0].size

def part1
    visited = Set.new()

    visit = lambda do |y, x|
        area = 1
        perimeter = 0
        value = @map[y][x]

        NEIS.each do |dy, dx|
            new_y = y + dy
            new_x = x + dx
            if new_y < 0 || new_x < 0 || new_y >= @len || new_x >= @wid || @map[new_y][new_x] != value
                perimeter += 1
                next
            end
            next unless visited.add?([new_y, new_x])
            rec = visit[new_y, new_x]

            area += rec[0]
            perimeter += rec[1]
        end
        [area, perimeter]
    end
    sum = 0
    0.upto(@len - 1) do |y|
        0.upto(@wid - 1) do |x|
            next unless visited.add?([y, x])
            sum += visit[y, x].inject(:*)
        end
    end
    sum
end

def part2
    visited = Set.new()

    visit = lambda do |y, x, borders|
        area = 1
        perimeter = 0
        value = @map[y][x]

        NEIS.each_with_index do |(dy, dx), dir|
            new_y = y + dy
            new_x = x + dx
            if new_y < 0 || new_x < 0 || new_y >= @len || new_x >= @wid || @map[new_y][new_x] != value
                borders << [y, x, dir]
                next
            end
            next unless visited.add?([new_y, new_x])
            rec = visit[new_y, new_x, borders]

            area += rec[0]
        end
        [area, borders]
    end

    visit_border = lambda do |y, x, dir, borders, visited_borders|
        if dir < 2
            if borders.include?([y - 1, x, dir]) && visited_borders.add?([y - 1, x, dir])
                visit_border[y - 1, x, dir, borders, visited_borders]
            end
            if borders.include?([y + 1, x, dir]) && visited_borders.add?([y + 1, x, dir])
                visit_border[y + 1, x, dir, borders, visited_borders]
            end
        else
            if borders.include?([y, x - 1, dir]) && visited_borders.add?([y, x - 1, dir])
                visit_border[y, x - 1, dir, borders, visited_borders]
            end
            if borders.include?([y, x + 1, dir]) && visited_borders.add?([y, x + 1, dir])
                visit_border[y, x + 1, dir, borders, visited_borders]
            end
        end
    end
    sum = 0
    0.upto(@len - 1) do |y|
        0.upto(@wid - 1) do |x|
            next unless visited.add?([y, x])
            area, borders = visit[y, x, Set.new]
            visited_borders = Set.new
            perimeter = borders.sum do |y, x, dir|
                next 0 unless visited_borders.add?([y, x, dir])
                visit_border[y, x, dir, borders, visited_borders]
                1
            end
            sum += area * perimeter
        end
    end
    sum
end

p part1
p part2