class KnightPathFinder
    attr_accessor :root_node
    MOVES = [
        [1,2],
        [2,1],
        [2,-1],
        [1,-2],
        [-1,-2],
        [-2,-1],
        [-2,1],
        [-1,2]
    ].freeze

    def initialize(pos)
        @start=pos
        @considered_pos = [pos]
        build_move_tree
    end

    def find_path(final_pos)
        final_node = root_node.bfs(final_pos)
        path = trace_path_back(final_node)
        p path
    end

    def trace_path_back(final_node)
        path=[]
        node=final_node
        while (node.parent!=nil)
            path << node.value
            node=node.parent
        end
        path << root_node.value
        path.reverse
    end

    def build_move_tree
        self.root_node=PolyTreeNode.new(@start)
        queue=[root_node]
        until  queue.empty?
            el = queue.shift
            #process el
            moves = new_move_positions(el.value)
            moves.each do |move|
                node = PolyTreeNode.new(move)
                el.add_child(node)
                queue<<node
            end
        end
    end

    def self.valid_moves(pos)
        moves=[]
        MOVES.each do |move|
            x = pos[0] + move[0]
            y = pos[1] + move[1]
            moves << [x,y] if ((0...8).include?(x) && (0...8).include?(y));
        end
        moves
    end

    def new_move_positions(pos)
        #filters out valid moves that are already in considered_pos
        moves = KnightPathFinder.valid_moves(pos)
        new_moves=[]
        moves.each do |move|
            if !@considered_pos.include? (move)
                new_moves << move 
                @considered_pos << move
            end
        end
        new_moves
    end
end

class PolyTreeNode
    attr_reader :value, :parent, :children
    
    def initialize(val)
        @value=val
        @parent=nil
        @children=[]
    end

    def parent=(node)
        self.parent.set_children.delete(self) if !self.parent.nil?
        @parent = node
        self.parent.set_children << self if !self.parent.nil?
    end

    def parent
        @parent
    end

    def add_child(node)
        node.parent=(self)
    end

    def remove_child(node)
        raise "error" if node.parent == nil
        node.parent=nil
    end

    def inspect
        { 'value' => @value, 'parent_value' => @parent.value }.inspect
    end

    def set_children
        @children
    end

    #searches
    def dfs(target=nil)
        return self if @value==target
        self.set_children.each do |child|
            search_value = child.dfs(target)
            return search_value unless search_value.nil?
        end
        nil
    end

    def bfs(target)
        queue=[self]
        while !queue.empty?
            el = queue.shift
            return el if el.value==target
            el.set_children.each {|child| queue << child}
        end
        nil
    end

end

kpf = KnightPathFinder.new([0, 0])
kpf.find_path([7, 6]) # => [[0, 0], [1, 2], [2, 4], [3, 6], [5, 5], [7, 6]]
kpf.find_path([6, 2]) # => [[0, 0], [1, 2], [2, 0], [4, 1], [6, 2]]