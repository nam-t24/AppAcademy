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