require 'ruby2d'

set background: 'navy'
set title: 'Snake'
set fps_cap: 20

# width = 640 / 20 = 32
# height = 480 / 20 = 24
# So a grid of 20 is 32 by 24

GRID_SIZE = 20
GRID_WIDTH = Window.width / GRID_SIZE
GRID_HEIGHT = Window.height / GRID_SIZE

class Snake
    attr_writer :direction
    def initialize
        # Our snake's starting position, and direction.
        @positions = [[2,0], [2,1], [2,2], [2,3]]
        @direction = 'down'
        @growing = false
    end

    def draw
        @positions.each do |position|
            Square.new(
                x: position[0] * GRID_SIZE, y: position[1] * GRID_SIZE, size: GRID_SIZE - 1, color: 'white'
            )
        end
    end
    
    def move
    if !@growing
        @positions.shift
    end
     case @direction 
     when 'down'
        @positions.push(new_coords(head[0], head[1] + 1))
     when 'up'
        @positions.push(new_coords(head[0], head[1] - 1))
     when 'right'
        @positions.push(new_coords(head[0] + 1, head[1]))
     when 'left'
        @positions.push(new_coords(head[0] - 1, head[1]))

     end
     @growing = false
    end
    def can_change_direction_to?(new_direction)
        case @direction 
        when 'up' then new_direction != 'down'
        when 'down' then new_direction != 'up'
        when 'right' then new_direction != 'left'
        when 'left' then new_direction != 'right'
        end
    end

    def x
        head[0]
    end

    def y 
        head[1]
    end

    def grow 
        @growing = true
    end
    private

    def new_coords(x, y)
        [x % GRID_WIDTH, y % GRID_HEIGHT]
    end

    #Grabs the head of the snake
    def head 
        @positions.last
    end

end

class Game 
    def initialize
        @score = 0
        @food_x = rand(GRID_WIDTH)
        @food_y = rand(GRID_HEIGHT)
    end
    def draw
        
        Square.new(
        x: @food_x * GRID_SIZE, y: @food_y * GRID_SIZE, size: GRID_SIZE, color: 'yellow'
        )

        Text.new("Score: #{@score}", color: "white", x: 10, y: 10, size: 20)
        
    end

    def snake_hit_food?(x, y)
        @food_x == x && @food_y == y 
    end

    def record_hit
        @score += 1
        @food_x = rand(GRID_WIDTH)
        @food_y = rand(GRID_HEIGHT)        
    end
end

snake = Snake.new 
game = Game.new
#snake.draw

#Updates every frame
update do 
    clear

    snake.move
    snake.draw
    game.draw

    if game.snake_hit_food?(snake.x, snake.y)
        game.record_hit 
        snake.grow
    end
end

on :key_down do |event|
    if ['up', 'down', 'left', 'right'].include?(event.key)
        if snake.can_change_direction_to?(event.key)
            snake.direction = event.key
        end
    end
end
show