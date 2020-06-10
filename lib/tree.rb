require 'pry'
require_relative 'node.rb'

class Tree
  attr_reader :root, :array
  def initialize(array)
    @array = array.sort.uniq
    @root = build_tree(@array)
  end

  def build_tree(array)
    return nil if array.empty?
    return Node.new(array[0]) if array.length < 2
    mid = array.length / 2
    root = Node.new(array[mid])
    root.left = build_tree(array[0...mid])
    root.right = build_tree(array[mid+1..-1])
    root
  end

  def update_root(node)
    @root = node
  end

  def insert(val, root = @root)
    if val < root.val
      root.left.nil? ? root.left = Node.new(val) : insert(val, root.left)
    elsif val > root.val
      root.right.nil? ? root.right = Node.new(val) : insert(val, root.right)
    end
  end

  def delete(val)
    node = find(val)
    return nil if node.nil?
    remove(node)
  end

  def remove(node)
    if node.left.nil? && node.right.nil?
      parent = find_parent(node)
      parent.left == node ? parent.left = nil : parent.right = nil
    elsif node.right.nil?
      remove_one_child(find_parent(node), node, node.left)
    elsif node.left.nil?
      remove_one_child(find_parent(node), node, node.right)
    else
      remove_two_children(node)
    end
  end

  def remove_one_child(parent, child, new_child)
    if parent.left == child
      parent.left = new_child
    else
      parent.right = new_child
    end
  end

  def remove_two_children(node)
    min_node = find_min_node(node.right)
    node.val = min_node.val
    remove(min_node)
  end

  def find_min_node(node)
    if node.left.nil?
      return node
    else
      find_min_node(node.left)
    end
  end

  def find_parent(node, read = @root)
    return nil if node.nil? || node == @root
    until read.left == node || read.right == node do
      node.val < read.val ? read = read.left : read = read.right
    end
    return read
  end

  def update_parent(parent, node)
    node.val > parent.val ? parent.right = node : parent.left = node
  end

  def find(val, read = @root)
    return nil if read.nil?
    if val == read.val
      return read
    elsif val < read.val
      find(val, read.left)
    else
      find(val, read.right)
    end
  end

  [:pre_order, :in_order, :post_order].each do |method|
    define_method(method) do |node = @root, arr = []|
      return if node.nil?
      block_given? ? yield(node) : arr << node.val if method == :pre_order
      self.send(method, node.left, arr)
      block_given? ? yield(node) : arr << node.val if method == :in_order
      self.send(method, node.right, arr)
      block_given? ? yield(node) : arr << node.val if method == :post_order
      arr unless block_given?
    end
  end

  def level_order(read = @root, queue = [@root], output = [])
    while !queue.empty?
      read = queue.shift
      queue.push(read.left) unless read.left.nil?
      queue.push(read.right) unless read.right.nil?
      output.push(read.val)
    end
    block_given? ? yield(output) : output
  end

  def level_order_with_depth(read = @root)
    tree = pre_order(read)
    output = [[]]
    depth(tree[-1]).times {output << []}
    level_order(read).each do |val|
      output[depth(find(val))] << val
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

  def weight(root = @root)
    root.left.nil? ? left = 0 : left = depth(pre_order(root.left)[-1], root)
    root.right.nil? ? right = 0 : right = depth(pre_order(root.right)[-1], root)
    left - right
  end

  def balanced?(node = @root)
    weight(node).between?(-1, 1)
  end

  def rebalance(root = @root)
    if root == @root
      on_root = true 
    else
      on_root = false
      parent = find_parent(root)
    end
    rotations = 0
    while !balanced?(root) do
      if weight(root) < -1
        root = rotate_left(root)
        on_root ? update_root(root) : update_parent(parent, root)
        rotations += 1
      else
        root = rotate_right(root)
        on_root ? update_root(root) : update_parent(parent, root)
        rotations += 1
      end
    end
    "Node balanced in #{rotations} rotations"
  end

  def rebalance_two(root = @root)
    arr = self.level_order
    @root = build_tree(arr.sort.uniq)
  end

  def rotate_right(node)
    left = node.left
    node.left = left.right
    left.right = node
    return left
  end

  def rotate_left(node)
    right = node.right
    node.right = right.left
    right.left = node
    return right
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
p x.level_order 
p x.level_order_with_depth




