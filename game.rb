require_relative "board.rb"
require_relative "player.rb"

class Game
    attr_reader :player, :board
    attr_accessor :lose
    
    def initialize
        @player = Player.new
        @board = Board.new
    end

      #This method is for turning the position which the user enter from this "x, y" to [x, y]
    def turn_pos(pos)
        new_pos = pos.split(",").map{ |idx| idx.to_i}
        new_pos
    end

    def count_mines(pos)
        self.board.count_mines(pos)
    end

    #this method asks the player for his name and welcomes him
    def alert_and_welcome
        self.player.alert_for_name
        self.player.welcome_player
    end
  
    def print_board
        self.board.print_board
    end

    def set_board
        self.board.set_mines_to_random_positions
    end

    def alert_first_entering
        player.alert_for_first_entering
    end

    def enter_position
        self.player.enter_position
    end

    def valid_pos?(pos)
        self.player.valid_pos?(pos)
    end

    def is_zero_mines?(pos)
        self.count_mines(pos) == 0
    end

    def enter_again
        self.player.enter_again
    end

    def set_pos(pos)
        self.board.set_entered_pos(pos)
    end

    def [](pos)
        self.board[pos]
    end

    def mines_positions
        self.board.mines_positions
    end

    def win?
        nums_pos = self.board.generate_nums_positions
        result = nums_pos.any?{ |pos| self[pos] == "-"}
        !result
    end

    def lose?
        self.lose
    end


    def alert_winning
        self.player.alert_winning
    end

    def alert_losing
        self.player.alert_losing
    end

    def gameOver
        self.win? || self.lose?
    end
    #first_pos: is the position which the player starts the game with
    #First position the player enters must be an position that has 0 neighbouring mines
    def enter_first_position
        self.alert_first_entering

        first_pos = self.enter_position
        #turning the position entered from "x, y" to [x, y]
        turned_pos = self.turn_pos(first_pos)
        

        until self.valid_pos?(first_pos) && self.is_zero_mines?(turned_pos) && !self.mines_positions.include?(turned_pos)
            first_pos = self.enter_again
            turned_pos = self.turn_pos(first_pos)
        end

        self.set_pos(turned_pos)
    end

    #This method is for all positions except the first position that the player enters
    def enter_turns_position
        pos = self.enter_position
        until self.valid_pos?(pos)
            pos = self.enter_again
        end
        turned_pos = self.turn_pos(pos)
        result = self.set_pos(turned_pos)

        #Here I end game if the result of setting position = false and that means that the entered position has X and the player lost
        self.lose = true if !result
    
    end



    def run
        self.alert_and_welcome
        self.set_board
        self.print_board
        self.enter_first_position

        until self.gameOver
           self.print_board
           self.enter_turns_position
        end

        self.win? ? self.alert_winning : self.alert_losing
    end
end

game = Game.new
game.run