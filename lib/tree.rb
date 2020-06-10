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

  def insert(val, root = @root)
    return if !find(val).nil?
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
    output
  end

  def level_order_with_depth(read = @root)
    output = [[]]
    depth.times {output << []}
    level_order(read).each_with_index do |val, idx|
      idx == 0 ? output[0] << val : output[how_deep?(val)] << val
    end
    output
  end

  def depth(node = @root)
    return -1 if node.nil?
    left = depth(node.left)
    right = depth(node.right)
    left > right ? left + 1 : right + 1
  end

  def how_deep?(val, parents = 0)
    return parents if val == @root.val
    node = find_parent(find(val))
    how_deep?(node.val, parents + 1)
  end

  def balanced?(node = @root)
    weight = depth(root.left) - depth(root.right)
    weight.between?(-1, 1)
  end

  def rebalance(root = @root)
    arr = self.level_order
    @root = build_tree(arr.sort.uniq)
  end

end
