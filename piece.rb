# Represents a piece on a Xycos board
class Piece
  attr_reader :speed, :strength, :type, :x, :y, :owner
  attr_accessor :recently_moved, :destroyed

  def initialize(type, x, y, owner)
    case type
    when :pawn            then initialize_pawn
    when :bishop, :knight then initialize_knight
    when :rook            then intialize_rook
    when :queen, :king    then initialize_queen
    end

    set_position(x, y)

    @owner          = owner
    @recently_moved = false
    @destroyed      = false
  end

  def single_char_representation
    case @type
    when :pawn            then owner.pawn_sprite
    when :bishop, :knight then owner.knight_sprite
    when :rook            then owner.rook_sprite
    when :queen, :king    then owner.queen_sprite
    end
  end

  def set_position(x, y)
    @x = x
    @y = y
  end

  private

  def initialize_pawn
    @speed    = 1
    @strength = 4
    @type     = :pawn
  end

  def initialize_knight
    @speed    = 2
    @strength = 3
    @type     = :knight
  end

  def intialize_rook
    @speed    = 3
    @strength = 2
    @type     = :rook
  end

  def initialize_queen
    @speed    = 4
    @strength = 1
    @type     = :queen
  end
end
