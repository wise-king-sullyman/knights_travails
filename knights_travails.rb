# frozen_string_literal: true

# Responsible for creating, updating, and drawing the chess board
class Board
  def initialize
    @board = make_blank_board
  end

  def update(row, column, char)
    @board[row][column] = char
  end

  def to_s
    s = ''
    @board.each do |row|
      row.each do |char|
        s += char
      end
      s += "\n"
    end
    s
  end

  private

  def make_blank_board
    board = []
    8.times { board.push([]) }
    board.each { |row| 8.times { row.push(("\u25A1".encode + ' ')) } }
    board
  end
end

# Responsible for the creation, drawing, and path finding of the knight
class Knight
  def initialize(location, destination)
    @board = Board.new
    @root = Moves.new(location.first, location.last)
    @destination = destination
    @last_move = nil
    draw_move(location.first, location.last)
    draw_destination
  end

  def find_path
    destination_found = nil
    until destination_found
      add_tree_layer
      prune_tree
      destination_found = level_order.index { |move| move.tile == @destination }
    end
    final_move = level_order[destination_found]
    print_path(path_from_final_move(final_move))
  end

  private

  def draw_move(row, column)
    @board.update(@last_move.first, @last_move.last, ("\u25A1".encode + ' ')) if @last_move
    @board.update(row, column, ("\u265E".encode + ' '))
    @last_move = [row, column]
  end

  def draw_destination
    @board.update(@destination.first, @destination.last, ("\u2654".encode + ' '))
  end

  def add_tree_layer
    level_order.reverse.each do |node|
      break unless node.next_moves.empty?

      node.possible_moves
    end
  end

  def level_order(node = @root, moves = [], queue = [])
    moves.push(node)
    node.next_moves.each { |move| queue.push(move) }
    level_order(queue.shift, moves, queue) unless queue.empty?
    moves
  end

  def prune_tree
    covered_tiles = []
    level_order.each do |move|
      if covered_tiles.include?(move.tile)
        move.delete
      else
        covered_tiles.push(move.tile)
      end
    end
  end

  def path_from_final_move(final_move)
    path = []
    move = final_move
    while move
      path.unshift(move.tile)
      move = move.parent
    end
    path
  end

  def print_path(moves)
    moves.each do |move|
      draw_move(move.first, move.last)
      puts @board
      puts "\n"
    end
  end
end

# Responsible for the creation, evaluation, and deletion of 'move' nodes
class Moves
  attr_accessor :next_moves, :parent, :tile
  def initialize(row, column, parent = nil)
    @row = row
    @column = column
    @tile = [row, column]
    @parent = parent
    @next_moves = []
  end

  def possible_moves
    row = 0
    column = 0
    while row < 8
      @next_moves.push(Moves.new(row, column % 8, self)) if legal(row, column % 8)
      row += 1 if column % 8 == 7
      column += 1
    end
    @next_moves
  end

  def delete
    parent.next_moves.delete(self)
  end

  private

  def legal(row, column)
    return false unless row.between?(0, 7) && column.between?(0, 7)

    row_diff = (@row - row).abs
    col_diff = (@column - column).abs
    true if row_diff == 2 && col_diff == 1 || row_diff == 1 && col_diff == 2
  end
end

def knight_moves(from, to)
  knight = Knight.new(from, to)
  knight.find_path
end

knight_moves([3, 3], [4, 3])
