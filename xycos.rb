require_relative 'constants'
require_relative 'board'
require_relative 'board_renderer'
require_relative 'player'
require_relative 'base_ai'

# The main application
class Xycos
  attr_reader :board, :board_renderer
  attr_reader :players
  attr_accessor :pending_moves, :recently_moved_pieces
  attr_accessor :round_number, :game_running

  def initialize
    @board = Board.new(Constants.board_size, Constants.board_size)

    p1_sprites = {
      pawn:   'p',
      knight: 'k',
      rook:   'r',
      queen:  'q'
    }

    p2_sprites = {
      pawn:   '1',
      knight: '2',
      rook:   '3',
      queen:  '4'
    }

    @players = [
      Player.new('Player 1', :standard_black, BaseAi, p1_sprites),
      Player.new('Player 2', :standard_white, BaseAi, p2_sprites)
    ]

    @players.each do |p|
      @board.add_pieces_from_player(p)
    end

    @board_renderer = BoardRenderer.new(@board)

    @round_number = 1
  end

  def start
    @game_running = true

    while @game_running
      start_round
      move_round
      combat_round
      determine_winner
      @round_number += 1
    end
  end

  def start_round
    print_header
    render
  end

  def move_round
    puts 'Move round'
    pick_moves
    execute_move
    render
  end

  def combat_round
    puts 'Combat round'
    do_combat
    kill_pieces
    render
  end

  def print_header
    puts '-----------------------------------------------------'
    puts '   Round ' + @round_number.to_s
    puts '-----------------------------------------------------'
  end

  def pick_moves
    @pending_moves = []

    @players.each do |player|
      @pending_moves.push player.pick_move
    end
  end

  def execute_move
    @recently_moved_pieces = []

    @pending_moves.each do |move|
      @board.execute_move(move)
      @recently_moved_pieces.push(move.piece)
    end
  end

  def do_combat
    @recently_moved_pieces.each do |piece|
      if !piece.destroyed
        if @board.multiple_pieces_occupy? piece.x, piece.y
          puts 'Multiple pieces occupy ' + piece.x.to_s + ',' + piece.y.to_s
          @board.destroy_all_on_cell piece.x, piece.y
        else
          @board.fight_nearby_enemies(piece)
        end
      end

      piece.recently_moved = false
    end
  end

  def kill_pieces
    @players.each do |player|
      player.clear_dead_pieces
    end
  end

  def determine_winner
    check_for_home_capture
    check_for_winners
  end

  def check_for_winners
    still_alive = @players.select { |p| !p.lost_game }

    if still_alive.size == 1
      declare_winner(still_alive[0])
    elsif still_alive.size == 0
      declare_tie
    end
  end

  def check_for_home_capture
    @players.each do |player|
      if @board.home_captured? player
        player.lost_game = true
      end
    end
  end

  def declare_winner(player)
    puts player.name + ' has won!'
    @game_running = false
  end

  def declare_tie
    puts 'The game is a tie!'
    @game_running = false
  end

  def render
    @board_renderer.render
  end
end

xycos = Xycos.new
xycos.start
