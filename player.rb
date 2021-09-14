class Player
    attr_reader :name

    def initialize
        @name = "Hisham"
    end


    def alert_for_name
        puts
        puts "What's your name"
        @name = gets.chomp
        puts
    end

    def welcome_player
        puts "Welcome, #{@name}"
    end

    def enter_position
        puts "Enter a position in this state: x, y "
        pos = gets.chomp
    end

    def has_str?(pos)
        chars = ("a".."z").to_a
        chars.any? { |char| pos.include?(char)}
    end

    def allowed_idx?(idx)
        idx <= 8 && idx >= 0 
    end

    def valid_pos?(pos)
        splitted = pos.split(",")
        first_idx = splitted.first.to_i
        second_idx = splitted.last.to_i

        return false unless splitted.length == 2
        return false  if self.has_str?(pos)
        return false unless ( allowed_idx?(first_idx) && allowed_idx?(second_idx) )
        true
    end

    def alert_for_first_entering
        puts
        puts "The first pos must be empty"
    end

    def enter_again
        puts "Incorrect pos, please enter again"
        gets.chomp
    end

    def alert_winning
        puts "----------------------------------------"
        puts "congratulations, #{self.name} you won ;"
        puts "----------------------------------------"
    end
    def alert_losing
        puts "----------------------------------------"
        puts "You lost the game, #{self.name} "
        puts "----------------------------------------"
    end

end