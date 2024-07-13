class Player
    def initialize(is_player_one=true)
        @is_player_one=is_player_one
        if is_player_one
            colors = ['yellow', 'orange', 'red', ]
        else
            colors = ['fuchsia', 'blue', 'green', ]
        end
        @color = colos.sample

    end

    def color
        @color.capitalize
    end

    def start_position()
        xpos = if @is_player_one
            GRID_WIDTH * 2 / 3
          else
            GRID_WIDTH / 3
          end
          return [[xpos, GRID_HEIGHT - 3], [xpos, GRID_HEIGHT - 4], [xpos, GRID_HEIGHT - 5]]
    end
end