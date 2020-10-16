# frozen_string_literal: true

class Board
  def initialize
    @board = make_blank_board
  end

  def make_blank_board
    board = []
    8.times { board.push([]) }
    board.each { |row| 8.times { row.push('# ') } }
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
    @destination = destination
    move(@location.first, @location.last)
    draw_destination
  end

  def move(row, column)
    @board.update(row, column, 'X ')
  end

  def draw_destination
    @board.update(@destination.first, @destination.last, 'O ')
  end

  def possible_moves(location = @location)
    moves = []
    x = -1
    8.times do
      x += 1
      y = -1
      8.times do
        y += 1
        pos_move = Moves.new(x, y)
        moves.push(pos_move) if pos_move.legal(location)
      end
    end
    moves.each { |pos_move| move(pos_move.row, pos_move.column)}
  end
end

class Moves
  include Comparable
  attr_accessor :row, :column
  def initialize(row, column)
    @row = row
    @column = column
    possible_moves = []
  end

  def legal(location)
    return false unless @row.between?(0, 7) && @column.between?(0, 7)

    return false if @row == location.first && @column == location.last
    
    row_diff = (location.first - @row).abs
    col_diff = (location.last - @column).abs
    true if row_diff == 2 && col_diff == 1 || row_diff == 1 && col_diff == 2
  end
end

def knight_moves(from, to)
end

knight = Knight.new([1, 5], [6, 2])
#puts knight.board
knight.possible_moves
puts knight.board
