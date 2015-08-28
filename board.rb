require_relative 'piece'

# Represents a Xycos board
class Board
  attr_reader :width, :height, :size

  def initialize(height, width)
    @width  = height
    @height = width
    @size   = height * width

    @cells  = Array.new(@size) { [] }
  end

  def add_pieces_from_player(player)
    player.pieces.each do |p|
      add_to_cell(p)
    end
  end

  # Returns a list of pieces on a board indexed at position x and y
  def read_cell(x, y)
    offset = (y * @height) + x

    @cells[offset] if x >= 0 && y >= 0 && x < @width && y < @height
  end

  # Adds a piece to a cell on the board
  def add_to_cell(piece)
    cell = read_cell(piece.x, piece.y)
    cell.push(piece)
  end

  def execute_move(move)
    cell = read_cell(move.piece.x, move.piece.y)
    index = cell.index(move.piece)

    if index.nil?
      message = 'Piece not found for moving: '+ move.piece.type.to_s
      message += '. Cell contents at ' + move.piece.x.to_s + ','
      message += move.piece.y.to_s + ': ' + cell.to_s
      message += ' for requested move to ' + move.to[:x].to_s
      message += ',' + move.to[:y].to_s

      fail message
    end

    cell.delete_at(index)

    move.execute_move
    add_to_cell(move.piece)
  end

  def multiple_pieces_occupy?(x, y)
    cell = read_cell(x, y)
    cell.size > 1
  end

  def destroy_all_on_cell(x, y)
    cell = read_cell(x, y)

    cell.each do |piece|
      piece.destroyed = true
      puts piece.owner.name + ' - ' + piece.type.to_s + ' killed'
    end

    cell.clear
  end

  def fight_nearby_enemies(piece)
    enemies = find_nearby_enemies(piece)

    enemies[:fighters].each do |fighter|
      puts 'Combat!'
      if fighter.strength > piece.strength
        destroy_all_on_cell(piece.x, piece.y)
      elsif fighter.strength == piece.strength
        destroy_all_on_cell(piece.x, piece.y)
        destroy_all_on_cell(fighter.x, fighter.y)
      else
        destroy_all_on_cell(fighter.x, fighter.y)
      end
    end

    if !piece.destroyed
      enemies[:passives].each do |passive|
        puts 'Slaughter'
        destroy_all_on_cell(passive.x, passive.y)
      end
    end
  end

  def find_nearby_enemies(piece)
    passives  = []
    fighters = []

    (-1..1).each do |offset_x|
      (-1..1).each do |offset_y|
        cell = read_cell(piece.x + offset_x, piece.y + offset_y)

        sort_enemies(cell, piece, passives, fighters) unless cell.nil?
      end
    end

    { passives: passives, fighters: fighters }
  end

  def sort_enemies(cell, piece, passives, fighters)
    cell.each do |other_piece|
      if other_piece.owner != piece.owner
        if other_piece.recently_moved
          fighters.push(other_piece)
        else
          passives.push(other_piece)
        end
      end
    end
  end

  def home_captured?(player)
    cell = read_cell(player.home[:x], player.home[:y])

    cell.each do |piece|
      true if (piece.owner != player)
    end

    false
  end
end
