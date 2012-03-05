require 'finite_state_machine'

s1 = [0, 1, 2, 3]
l1 = %w[a b]
q01 = 0
f1 = [1, 2]
d1 = {
		0 => {'a' => 0, 'b' => 1},
		1 => {'a' => 1, 'b' => 2},
		2 => {'a' => 2, 'b' => 3},
		3 => {'a' => 3, 'b' => 3},
	}
m1 = FiniteStateMachine.new s1, l1, d1, q01, f1
	
s2 = [0, 1]
l2 = %w[a b]
q02 = 0
f2 = [0]
d2 = {
		0 => {'a' => 1, 'b' => 0},
		1 => {'a' => 0, 'b' => 1},
	}
m2 = FiniteStateMachine.new s2, l2, d2, q02, f2

s3 = [0, 1, 2, 3, 4]
l3 = %w[a b]
q03 = 0
f3 = [0, 4]
d3 = {
		0 => {'e' => 1},
		1 => {'a' => 2},
		2 => {'e' => 3},
		3 => {'b' => 4},
		4 => {'e' => 1},
	}
m3 = FiniteStateMachine.new s3, l3, d3, q03, f3

str = "ababaa"

puts "#{"*"*5} M1 #{"*"*5}"
puts m1
puts

puts "#{"*"*5} M2 #{"*"*5}"
puts m2
outcome = m2.process str
puts "string #{str} accepted: #{outcome}"
puts

puts "#{"*"*5} M1 union M2 #{"*"*5}"
puts m1.union m2
puts

puts "#{"*"*5} M1 intersect M2 #{"*"*5}"
puts m1.intersection m2
puts

puts "#{"*"*5} M3 #{"*"*5}"
puts m3
puts "Is deterministic: #{m3.deterministic?}"
outcome = m3.process ""
puts "empty string accepted: #{outcome}"
outcome = m3.process str
puts "string #{str} accepted: #{outcome}"
str = "abab"
outcome = m3.process str
puts "string #{str} accepted: #{outcome}"