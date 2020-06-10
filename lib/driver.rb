require_relative 'tree.rb'

puts "\nthis driver script tests the binary search tree"

test_array = Array.new(15) { rand(1..100) }
tree = Tree.new(test_array)
puts "\nnew tree made from random test array: #{test_array}"

puts "\ntree balanced? #{tree.balanced?}"
puts tree.weight
puts "\nlevel order:\n#{tree.level_order}"
puts "\nlevel order with depth: #{tree.level_order_with_depth}"
puts "\npreorder: #{tree.pre_order}"
puts "\npost order: #{tree.post_order}"
puts "\nin order: #{tree.in_order}"
puts "\nadding several small numbers to imbalance array (1, 2, 3, 4, 5, 6 , 7, 8, 9, 10, 11, 12, 13)"
[1, 2, 3, 4, 5, 6 , 7, 8, 9, 10, 11, 12, 13].each {|num| tree.insert(num)}
#puts "\nlevel order with depth: #{tree.level_order_with_depth}"
puts tree.weight
puts tree.depth(tree.find(13))
puts "\ntree balanced? #{tree.balanced?}"
#puts "\ntree balance is now: #{tree.balanced?} "


