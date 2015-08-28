# Responsible for rendering pieces
class PieceRenderer
  # Renders the top-most piece of the array
  def render(piece_list)
    output = ' -'

    if piece_list.size > 0
      piece_list.each do |piece|
        (output = ' ' + piece.single_char_representation) unless piece.nil?
      end
    end

    output
  end
end
