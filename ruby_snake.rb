require 'ruby2d'

set background: 'navy'
set title: 'Snake'
set fps_cap: 20

# width = 640 / 20 = 32
# height = 480 / 20 = 24
# So a grid of 20 is 32 by 24

GRID_SIZE = 20

class Snake
    def initialize
        # Our snake's starting position, and direction.
        @positions = [[2,0], [2,1], [2,2], [2,3]]
        @direction = 'down'
    end

    def draw
        @positions.each do |position|
            Square.new(
                x: position[0] * GRID_SIZE, y: position[1] * GRID_SIZE, size: GRID_SIZE - 1, color: 'white'
            )
        end
    end
    
    def move
    @positions.shift
     case @direction 
     when 'down'
        @positions.push([head[0], head[1] + 1])
     end
    end

    private
    #Grabs the head of the snake
    def head 
        @positions.last
    end

end

snake = Snake.new 
snake.draw

update do 
    clear

    snake.move
    snake.draw
end

show