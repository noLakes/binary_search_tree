require 'pry'
class Node
  include Comparable
  attr_accessor :val, :left_child, :right_child

  def initialize(val = nil)
    @val = val
    @left_child = nil
    @right_child = nil
  end

  def <=>(other)
    @val <=> other
  end

  def not_parent?
    self.left_child.nil? && self.right_child.nil?
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
    node = find(val)
    return nil if node.nil?
    remove(node)
  end

  def remove(node)
    if node.left_child.nil? && node.right_child.nil?
      parent = find_parent(node)
      parent.left_child == node ? parent.left_child = nil : parent.right_child = nil
    elsif node.right_child.nil?
      remove_one_child(find_parent(node), node, node.left_child)
    elsif node.left_child.nil?
      remove_one_child(find_parent(node), node, node.right_child)
    else
      remove_two_children(node)
    end
  end

  def remove_one_child(parent, child, new_child)
    if parent.left_child == child
      parent.left_child = new_child
    else
      parent.right_child = new_child
    end
  end

  def remove_two_children(node)
    min_node = find_min_node(node.right_child)
    node.val = min_node.val
    remove(min_node)
  end

  def find_min_node(node)
    if node.left_child.nil?
      return node
    else
      find_min_node(node.left_child)
    end
  end

  def find_parent(node, read = @root)
    return nil if node.nil? || node == @root
    until read.left_child == node || read.right_child == node do
      node.val < read.val ? read = read.left_child : read = read.right_child
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
  def pre_order(node = @root, result = [])
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
  def reverse_order(node = @root)
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

  def level_order(read = @root, queue = [@root], output = [])
    while !queue.empty?
      read = queue.shift
      queue.push(read.left_child) unless read.left_child.nil?
      queue.push(read.right_child) unless read.right_child.nil?
      output.push(read)
    end
    block_given? ? yield(output) : output
  end

  def level_order_with_empty(read = @root, queue = [@root], output = [])
    while !queue.empty? && queue.any?(Node)
      read = queue.shift
      if (read != 'nil')
        read.left_child ? queue.push(read.left_child) : queue.push('nil')
        read.right_child ? queue.push(read.right_child) : queue.push('nil')
        output.push(read)
      else
        output.push('nil')
        queue.push('nil', 'nil')
      end
    end
    block_given? ? yield(output) : output
  end

  def level_order_with_depth(read = @root)
    tree = pre_order(read)
    output = [[]]
    depth(tree[-1]).times {output << []}
    level_order(read).each do |node|
      output[depth(node)] << node.val
    end
    output
  end

  def depth(val, root = @root)
    node = find(val, root)
    return nil if node.nil?
    depth = 0
    while node != root do
      node = find_parent(node)
      depth += 1
    end
    depth
  end

  def balanced?(root = @root)
    root.left_child.nil? ? left = 0 : left = depth(pre_order(root.left_child)[-1])
    root.right_child.nil? ? right = 0 : right = depth(pre_order(root.right_child)[-1])
    (left - right).between?(-1, 1)
  end

  def rebalance(root = @root)
    until balanced?(root) do
      import = level_order(root) {|arry| arry.map {|node| node.val}}
      new_arry = []
      until import.empty? do
        new_arry << import.slice!(import.length / 2)
      end
      #binding.pry
      root = build_tree(new_arry)
    end
    pre_order(root)
  end

end

x = Tree.new([1, 7, 4, 23, 8, 9, 3, 5, 67, 6345, 324])

puts "pre-order"
p x.pre_order
puts "\nin-order"
p x.in_order
puts "\npost-order"
p x.post_order
puts "\nlevel-order"
p x.level_order {|arry| arry.map {|node| node.val}}
p x.level_order_with_depth
p x.balanced?
p x.rebalance