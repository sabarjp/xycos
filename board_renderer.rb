require_relative 'piece_renderer'

# Responsible for rendering a Xycos board
class BoardRenderer
  attr_reader :board

  def initialize(board)
    @board = board
    @piece_renderer = PieceRenderer.new
  end

  # Prints the board to the console
  def render
    @board.height.times do |x|
      @board.width.times do |y|
        cell = @board.read_cell(x, y)
        print @piece_renderer.render(cell)
      end
      puts
    end
  end
end
