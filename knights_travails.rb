# frozen_string_literal: true

class Board
  def initialize
    @board = make_blank_board
  end

  def make_blank_board
    board = []
    8.times { board.push([]) }
    board.each { |row| 8.times { row.push("\u25A1".encode + ' ') } }
    board
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
end

class Knight
  attr_accessor :board

  def initialize(location, destination)
    @board = Board.new
    @location = location
    @root = Moves.new(location.first, location.last)
    @destination = destination
    @last_move = nil
    draw_move(@location.first, @location.last)
    draw_destination
  end

  def draw_move(row, column)
    @board.update(@last_move.first, @last_move.last, ("\u25A1".encode + ' ')) if @last_move
    @board.update(row, column, ("\u265E".encode + ' '))
    @last_move = [row, column]
  end

  def draw_destination
    @board.update(@destination.first, @destination.last, ("\u2654".encode + ' '))
  end

  def possible_moves(location = @location)
    moves = []
    x = 0
    y = 0
    while x < 8
      pos_move = Moves.new(x, y % 8)
      moves.push(pos_move) if pos_move.legal(location)
      x += 1 if y % 8 == 7
      y += 1
    end
    moves
  end

  def find_path(location = @location, moves_made = [@location])
    possible_moves(location).each do |move|
      move_array = move.to_a
      moves_made.push(move_array) if move_array == @destination

      #find_path(move_array, moves_made)
    end
    moves_made
  end

  def print_path(moves)
    moves.each do |move|
      draw_move(move.first, move.last)
      puts @board
      puts "\n"
    end
  end
end

class Moves
  attr_accessor :row, :column, :next_moves
  def initialize(row, column)
    @row = row
    @column = column
    @next_moves = []
  end

  def legal(location)
    return false unless @row.between?(0, 7) && @column.between?(0, 7)

    return false if @row == location.first && @column == location.last
    
    row_diff = (location.first - @row).abs
    col_diff = (location.last - @column).abs
    true if row_diff == 2 && col_diff == 1 || row_diff == 1 && col_diff == 2
  end

  def to_a
    [@row, @column]
  end
end

def knight_moves(from, to)
end

knight = Knight.new([0, 0], [1, 2])
#puts knight.board
knight.print_path(knight.find_path)
