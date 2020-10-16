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

  def initialize
    @board = Board.new
  end

  def move(row, column)
    @board.update(row, column, 'X ')
  end

  def destination(row, column)
    @board.update(row, column, 'O ')
  end
end

def knight_moves(from, to)
end

knight = Knight.new
knight.move(1, 5)
knight.destination(6, 2)
puts knight.board
