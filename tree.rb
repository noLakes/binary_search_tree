
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

  def pre_order(node=@root)
    stack = []
    output = []
    read = node
    stack.push(read)
    while !stack.empty?
      read = stack.shift
      stack.push(read.left_child) unless read.left_child.nil?
      stack.push(read.right_child) unless read.right_child.nil?
      output.push(read.val)
    end
    output
  end

  def in_order(node=@root)
    stack = []
    output = []
    read = node
    while (read || !stack.empty?)
      while read
        stack.push(read)
        read = read.left_child
      end
      read = stack.pop
      output.push(read.val)
      read = read.right_child
    end
    output
  end

  def reverse_order(node=@root)
    stack = []
    output = []
    read = node
    while (read || !stack.empty?)
      while read
        stack.push(read)
        read = read.right_child
      end
      read = stack.pop
      output.push(read.val)
      read = read.left_child
    end
    output
  end

  #Left Right Root
  def post_order

  end

  def level_order
    #returns {0 => [root], 1 => [lvl1 vals] 2 => [lvl2 vals].....}
  end

end

x = Tree.new([1, 7, 4, 23, 8, 9, 3, 5, 67, 6345, 324])
puts x.in_order.join(' ')
puts x.reverse_order.join(' ')
puts x.pre_order.join(' ')