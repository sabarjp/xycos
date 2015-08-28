require_relative 'constants'

# Represents a proposed move for a piece
class Move
  attr_reader :piece, :to

  def initialize(piece, to)
    @piece = piece
    @to    = to
  end

  # Checks if the move is valid
  def valid?
    valid_distance? && in_bounds?
  end

  # Checks if the distance is valid
  def valid_distance?
    distance = (@to[:x] - @piece.x).abs + (@to[:y] - @piece.y).abs

    distance <= piece.speed
  end

  # Checks if the move is in bounds
  def in_bounds?
    @to[:x] >= 0 &&
      @to[:y] >= 0 &&
      @to[:x] < Constants.board_size &&
      @to[:y] < Constants.board_size
  end

  def execute_move
    message = piece.owner.name + ' - ' + piece.type.to_s
    message += ' from (' + piece.x.to_s + ',' + piece.y.to_s + ')'
    message += ' to (' + @to[:x].to_s + ',' + @to[:y].to_s + ')'
    puts(message)
    @piece.set_position(@to[:x], @to[:y])
    @piece.recently_moved = true
  end
end
