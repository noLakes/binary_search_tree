class Node
  include Comparable
  attr_accessor :val, :left, :right

  def initialize(val = nil)
    @val = val
    @left = nil
    @right = nil
  end

  def <=>(other)
    @val <=> other
  end

  def not_parent?
    self.left.nil? && self.right.nil?
  end
end