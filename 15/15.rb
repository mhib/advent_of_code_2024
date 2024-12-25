@map = []
@moves = []
@start = nil
filling_map = true
File.readlines('in.txt', chomp: true).each_with_index do |line, y|
    if line.empty?
        filling_map = false
        next
    end

    if filling_map
        chars = line.chars
        pos = chars.index('@')
        if pos
            @start = [y, pos]
        end
        @map << chars
    else
        @moves.push(*line.chars)
    end
end

DELTAS = {
    '^' => [-1, 0],
    '>' => [0, 1],
    'v' => [1, 0],
    '<' => [0, -1],
}

class Board
    def initialize(board, robot)
        @board = board
        @robot = robot
    end

    def move!(type)
        delta = DELTAS[type]
        new_robot = apply_move(@robot, delta)

        if board[new_robot[0]][new_robot[1]] == '.'
            @board[new_robot[0]][new_robot[1]], @board[@robot[0]][@robot[1]] = 
                @board[@robot[0]][@robot[1]], @board[new_robot[0]][new_robot[1]]
            @robot = new_robot
        elsif board[new_robot[0]][new_robot[1]] == '#'
            return
        else
            if move_boxes!(new_robot, delta)
                @board[new_robot[0]][new_robot[1]] = '@'
                @board[@robot[0]][@robot[1]] = '.'
                @robot = new_robot
            end
        end
    end

    def print
        @board.each { |l| puts l.join("") }
    end

    def gps_value
        sum = 0
        @board.each_with_index do |row, y|
            row.each_with_index do |cell, x|
                if cell == 'O'
                    sum += 100 * y + x
                end
            end
        end
        sum
    end

    private

    def apply_move(pos, delta)
        [pos[0] + delta[0], pos[1] + delta[1]]
    end


    def move_boxes!(new_robot, delta)
        pos = new_robot
        while @board[pos[0]][pos[1]] == 'O'
            pos = apply_move(pos, delta)
        end

        return false if @board[pos[0]][pos[1]] == '#'
        @board[pos[0]][pos[1]] = 'O'
    end

    attr_accessor :board, :robot

end

def part1
    board = Board.new(
        @map.map(&:dup),
        @start.dup
    )
    @moves.each do |x|
        board.move!(x)
    end
    board.print
    board.gps_value
end

p part1