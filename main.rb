class FiniteStateMachine
	def initialize(s, l, d, q0, f)
		@states = s
		@language = l
		@transitions = d
		@start = q0
		@final_states = f
	end
	def process(s)
		q = @start
		s.each_char { |c| q = @transitions[q][c]}
		@final_states.include? q
	end
	def union(fsm)
		
	end
	def intersection(fsm)
	end
end

s = [0..3]
l = %w[a, b]
q0 = 0
f = [1, 2]
d = {
		0 => {'a' => 0, 'b' => 1},
		1 => {'a' => 1, 'b' => 2},
		2 => {'a' => 2, 'b' => 3},
		3 => {'a' => 3, 'b' => 3},
	}

m = FiniteStateMachine.new s, l, d, q0, f
str = "abababa"
outcome = m.process str
puts "string #{str} accepted: #{outcome}"
