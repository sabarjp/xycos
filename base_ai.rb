# A basic AI, meant to be extended
class BaseAi
  attr_reader :player, :random

  def initialize(player)
    @player = player
    @random = Random.new
  end

  def pick_move
    new_move = nil

    while new_move.nil? || !new_move.valid? || already_occupied?(new_move)
      piece        = player.pieces.sample
      new_position = random_move_for_piece(piece)
      new_move     = Move.new(piece, new_position)
    end

    puts(@player.name + ' set')
    new_move
  end

  def random_move_for_piece(piece)
    x_move = @random.rand(-piece.speed..piece.speed)
    remaining_steps = piece.speed - x_move.abs
    y_move = @random.rand(-remaining_steps..remaining_steps)

    { x: piece.x + x_move, y: piece.y + y_move }
  end

  def already_occupied?(move)
    @player.pieces.each do |piece|
      if move.piece != piece && piece.x == move.to[:x] && piece.y == move.to[:y]
        return true
      end
    end

    false
  end
end
