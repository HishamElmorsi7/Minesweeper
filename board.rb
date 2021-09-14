require_relative "mine.rb"
require_relative "num.rb"
require_relative "player.rb"

class Board
    attr_accessor :board, :mines, :mines_positions

    NUM_OF_MINES = 10
    BOARD_SIZE = 9

    def initialize
        @board = Array.new(BOARD_SIZE){Array.new(BOARD_SIZE, "-" )}
        @mines = []
        @mines_positions = []
    end

    def print_cols_indices
        cols_indices = (0..BOARD_SIZE - 1).to_a.join("  ")
        print "\n     #{cols_indices}\n\n"
    end

    def print_rows_indices_and_cells
        board.each.each_with_index do |row, i|

            print "#{i}    "
            row.each do |col|

                if col == "-" 
                    print "-  "
                elsif col.visible
                    print "#{col.value}  "
                else
                    print "-  "
                end

            end
            
            print "\n"
        end
        # board.each_with_index { |row, i| print "#{i}  #{row.join("  ")} \n" }   
    end

    def print_board
        print_cols_indices
        print_rows_indices_and_cells
        return
    end

    def generate_board_positions
        positions = []
        self.board.each_with_index do |row, i|
            row.each_with_index { |col, j| positions << [i, j] }
        end
        positions
    end

    def generate_nums_positions
        board_positions = self.generate_board_positions
        mines_positions = self.generate_random_positions
        mines_positions.each { |pos| board_positions.delete(pos)}
        board_positions
    end

    def generate_board_mines
        #generating 9 mines 
        NUM_OF_MINES.times{ self.mines << Mine.new }
        self.mines
    end

    def generate_a_random_position
        main_indices = (0..BOARD_SIZE - 1).to_a
        [ main_indices.sample, main_indices.sample]
    end

    def generate_random_positions
        positions = self.mines_positions
        
        until positions.count == NUM_OF_MINES
            pos = generate_a_random_position
            positions << pos unless positions.include?(pos)
        end
        positions
    end

    def [](pos)
        row = pos.first
        col = pos.last
        self.board[row][col] 
    end

    def []=(pos, obj)
        row = pos.first
        col = pos.last
        self.board[row][col] = obj
    end


    def set_mines_to_random_positions
        mines = self.generate_board_mines
        random_positions = self.generate_random_positions 

        #distribution of mines in the random positions
        (0..NUM_OF_MINES - 1).each do |idx|

            random_position = random_positions[idx]
            mine = mines[idx]
            #assigning mine to the board's random position 
            self[random_position] = mine
        end

    end

    #Here are the operations for knowing 8 positions next to any position
    #posNum => represents a position


    def pos1(pos)
        [pos.first + 1, pos.last + 1]
    end
    def pos2(pos)
        [pos.first + 1, pos.last - 1]
        
    end
    def pos3(pos)
        [pos.first - 1, pos.last + 1]
        
    end
    def pos4(pos)
        [pos.first - 1, pos.last - 1]
    end
    def pos5(pos)
        [pos.first + 0, pos.last + 1]
    end
    def pos6(pos)
        [pos.first + 0, pos.last - 1]
        
    end
    def pos7(pos)
        [pos.first + 1, pos.last + 0]
        
    end
    def pos8(pos)
        [pos.first - 1, pos.last + 0]
    end

    #

    #generating 8 neighbouring positions of a position
    def get_neigbouring_positions(pos)
        [ pos1(pos), pos2(pos), pos3(pos), pos4(pos), pos5(pos), pos6(pos), pos7(pos), pos8(pos) ]
    end

    def false_pos?(pos)
        (pos.first < 0 || pos.last < 0) ||(pos.first > 8 || pos.last > 8)
    end
    #filtering neighbouring positions from negative ones
    def filter_neighbouring_positions(pos)
        all_neighbouring_positions = get_neigbouring_positions(pos)
        filtered = []
        
        all_neighbouring_positions.each { |pos| false_pos?(pos) ? next : filtered << pos }

        filtered
    end

  
    #counting mines around the position
    def count_mines(pos)
        count_mines = 0
        #filtered => filtered neighbouring positions
        filtered = self.filter_neighbouring_positions(pos)

        filtered.each do |filtered_pos|
            if self[filtered_pos] != "-"
                count_mines += 1 if self[filtered_pos].value == "X" 
            end
        end
     
        count_mines
    end
    #This handels what happens after I choose a position
    def set_entered_pos(pos)
    #returning -1 when losing
        unless self[pos] == "-"
            return false if self[pos].value == "X"
        end

        self.handle_pos(pos)

    end

    #This assigning num object to a specific pos of the board
    def creat_board_num(pos)
        mines_count = self.count_mines(pos)
        self[pos] = Num.new(mines_count)
    end

    #Using tree concept to go through the neighbouring positions
    def handle_pos(pos)
        # debugger
        self.creat_board_num(pos)
        pos_value = self[pos].value

        return pos if pos_value > 0

        neighbours = self.filter_neighbouring_positions(pos)
        neighbours.each do |nei_pos|
           self[nei_pos] == "-" ? handle_pos(nei_pos) : next
        end

        true
    end

end



