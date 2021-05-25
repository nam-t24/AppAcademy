require_relative 'tic_tac_toe'
require "byebug" 

class TicTacToeNode
  attr_reader :board, :next_mover_mark, :prev_move_pos

  def initialize(board, next_mover_mark, prev_move_pos = nil)
    @board=board
    @next_mover_mark=next_mover_mark
    @prev_move_pos=prev_move_pos
  end

  def losing_node?(evaluator)
    if board.over?
      return board.won? && board.winner != evaluator
    end

    if @next_mover_mark==evaluator
      self.children.all? {|node| node.losing_node?(evaluator)}
    else
      self.children.any? {|node| node.losing_node?(evaluator)}
    end
  end

  def winning_node?(evaluator)
    if board.over?
      #could be a tie
      return board.winner == evaluator
    end

    if next_mover_mark==evaluator
      self.children.any? {|node| node.winning_node?(evaluator)}
    else
      self.children.all? {|node| node.winning_node?(evaluator)}
    end
  end

  # This method generates an array of all moves that can be made after
  # the current move.
  def children
    spots=[]
    # debugger
    @board.rows.each_with_index do |row, row_idx|
      row.each_with_index do |spot, col_idx|
        if spot==nil
          pos = [row_idx, col_idx]

          dub_board=@board.dup
          dub_board[pos] = self.next_mover_mark
          next_mover_mark=(self.next_mover_mark == :x ? :o : :x)
          prev_move_pos=pos

          node = TicTacToeNode.new(dub_board, next_mover_mark, prev_move_pos)
          spots << node
        end
      end
    end
    spots
  end
end