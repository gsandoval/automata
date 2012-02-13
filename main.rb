require 'finite_state_machine'

s1 = Array.new(4) {|i| i}
l1 = %w[a b]
q01 = 0
f1 = [1, 2]
d1 = {
		0 => {'a' => 0, 'b' => 1},
		1 => {'a' => 1, 'b' => 2},
		2 => {'a' => 2, 'b' => 3},
		3 => {'a' => 3, 'b' => 3},
	}
	
s2 = Array.new(2) { |i| i }
l2 = %w[a b]
q02 = 0
f2 = [0]
d2 = {
		0 => {'a' => 1, 'b' => 0},
		1 => {'a' => 0, 'b' => 1},
	}

m1 = FiniteStateMachine.new s1, l1, d1, q01, f1
puts "M1"
puts m1
m2 = FiniteStateMachine.new s2, l2, d2, q02, f2
puts "M2"
puts m2
str = "ababaa"
outcome = m1.process str
puts "string #{str} accepted: #{outcome}"
puts "M1 union M2:"
puts m1.union m2
puts "M1 intersect M2:"
puts m1.intersection m2
