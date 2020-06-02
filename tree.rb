
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

  def end?
    self.left_child.nil? && self.right_child.nil? ? true : false
  end
end

class Tree
  attr_reader :root
  def initialize(arry=[nil])
    @root = build_tree(arry)
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

  def delete(val)

  end

  def find(val, read=@root)
    if val == read.val
      return read
    elsif read.end?
      return nil
    elsif val < read.val
      return nil if read.left_child.nil?
      find(val, read.left_child)
    else
      return nil if read.right_child.nil?
      find(val, read.right_child)
    end
  end
end

x = Tree.new([1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324])
