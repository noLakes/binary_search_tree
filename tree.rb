
class Node
  include Comparable
  attr_accessor :val, :left_child, :right_child

  def initialize(val = nil)
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
  def initialize(arry = [nil])
    @root = build_tree(arry)
  end

  def build_tree(arry)
    return nil unless arry[0]
    arry.uniq!
    new_tree = Node.new(arry.shift)
    arry.each do |item|
      insert(item, new_tree)
    end
    new_tree
  end

  def insert(val, root = @root)
    if val < root.val
      root.left_child.nil? ? root.left_child = Node.new(val) : insert(val, root.left_child)
    elsif val > root.val
      root.right_child.nil? ? root.right_child = Node.new(val) : insert(val, root.right_child)
    end
  end

  def delete(val)

  end

  def find_parent(val, read = @root)
    child = find(val)
    return nil if child.nil?
    until read.left_child == child || read.right_child == child do
      child.val < read.val ? read = read.left_child : read = read.right_child
    end
    return read
  end

  def find(val, read = @root)
    return nil if read.nil?
    if val == read.val
      return read
    elsif val < read.val
      find(val, read.left_child)
    else
      find(val, read.right_child)
    end
  end

  #Root Left Right
  def pre_order(node=@root, result = [])
    return if node.nil?
      block_given? ? yield(node) : result << node.val
      pre_order(node.left_child, result)
      pre_order(node.right_child, result)
    return result
  end

  #Left Root Right
  def in_order(node = @root, result = [])
    return if node.nil?
      in_order(node.left_child, result)
      block_given? ? yield(node) : result << node.val
      in_order(node.right_child, result)
    return result
  end

  #Right Root Left
  def reverse_order(node=@root)
    return if node.nil?
      reverse_order(node.right_child, result)
      block_given? ? yield(node) : result << node.val
      reverse_order(node.left_child, result)
    return result
  end
  
  #Left Right Root
  def post_order(node = @root, result = [])
    return if node.nil?
      post_order(node.left_child, result)
      post_order(node.right_child, result)
      block_given? ? yield(node) : result << node.val
    return result
  end

  def level_order
    #returns {0 => [root], 1 => [lvl1 vals] 2 => [lvl2 vals].....}
  end

end

x = Tree.new([1, 7, 4, 23, 8, 9, 3, 5, 67, 6345, 324])

puts "pre-order"
p x.pre_order
puts "\nin-order"
p x.in_order
puts "\npost-order"
p x.post_order

p x.find_parent(324)