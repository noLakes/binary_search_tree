
class Node
  include Comparable
  attr_accessor :val, :left_child, :right_child

  def initialize(val=nil)
    @val = val
    @left_child = nil
    @right_child = nil
  end

  def <=>(other)
    @val <=> other.val
  end
end

class Tree
  attr_reader :root
  def initialize(arry=[nil])
    @root = build_tree(arry)
    @read = @root
    @tmp = @read
  end

  def reset_read
    @read = @root
  end

  def read_left
    @read = @read.left_child
    @tmp = @read
  end

  def read_right
    @read = @read.right_child
    @tmp = @read
  end

  def build_tree(arry)
    arry.uniq!
    new_tree = Node.new(arry.shift)
    
    return new_tree if arry.length == 0 

    arry.each do |item|
      insert(item, new_tree)
    end
    new_tree
  end

  def insert(val, root=@root)
    if val < root.val
      root.left_child.nil? ? root.left_child = Node.new(val) : insert(val, root.left_child)
    elsif val > root.val
      root.right_child.nil? ? root.right_child = Node.new(val) : insert(val, root.right_child)
    end
  end

end

x = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
p x.root