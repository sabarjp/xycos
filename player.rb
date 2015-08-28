require_relative 'move'

# A Xycos player
class Player
  attr_reader :name, :ai, :home, :sprite_sheet
  attr_accessor :pieces, :lost_game

  def initialize(name, setup, ai, sprite_sheet)
    @name      = name
    @ai        = ai.new(self) unless ai.nil?
    @pieces    = []
    @lost_game = false

    @sprite_sheet = sprite_sheet

    case setup
    when :standard_white then create_standard_white_setup
    when :standard_black then create_standard_black_setup
    end
  end

  def pick_move
    if @ai
      ai.pick_move
    else
      fail 'Error: move - no AI loaded'
    end
  end

  def clear_dead_pieces
    @pieces.delete_if { |piece| piece.destroyed == true }

    puts @name + ' has ' + @pieces.size.to_s + ' pieces remaining'

    @lost_game = true unless @pieces.size > 0
  end

  def pawn_sprite
    @sprite_sheet[:pawn]
  end

  def knight_sprite
    @sprite_sheet[:knight]
  end

  def rook_sprite
    @sprite_sheet[:rook]
  end

  def queen_sprite
    @sprite_sheet[:queen]
  end

  private

  def create_standard_white_setup
    @home = { x: 0, y: 0 }
    create_standard_white_pieces
  end

  def create_standard_black_setup
    @home = { x: 9, y: 9 }
    create_standard_black_pieces
  end

  def create_standard_white_pieces
    pieces.push Piece.new(:queen,  0, 0, self)
    pieces.push Piece.new(:rook,   1, 0, self)
    pieces.push Piece.new(:rook,   0, 1, self)
    pieces.push Piece.new(:knight, 2, 0, self)
    pieces.push Piece.new(:bishop, 1, 1, self)
    pieces.push Piece.new(:knight, 0, 2, self)
    pieces.push Piece.new(:pawn,   3, 0, self)
    pieces.push Piece.new(:pawn,   2, 1, self)
    pieces.push Piece.new(:pawn,   0, 3, self)
    pieces.push Piece.new(:pawn,   1, 2, self)
  end

  def create_standard_black_pieces
    pieces.push Piece.new(:queen,  9, 9, self)
    pieces.push Piece.new(:rook,   8, 9, self)
    pieces.push Piece.new(:rook,   9, 8, self)
    pieces.push Piece.new(:knight, 7, 9, self)
    pieces.push Piece.new(:bishop, 8, 8, self)
    pieces.push Piece.new(:knight, 9, 7, self)
    pieces.push Piece.new(:pawn,   6, 9, self)
    pieces.push Piece.new(:pawn,   7, 8, self)
    pieces.push Piece.new(:pawn,   9, 6, self)
    pieces.push Piece.new(:pawn,   8, 7, self)
  end
end
