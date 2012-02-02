class FiniteStateMachine
	attr_accessor :states, :alphabet, :transitions, :initial_state, :final_states
	def initialize(s, l, d, q0, f)
		@states = s
		@alphabet = l
		@transitions = d
		@initial_state = q0
		@final_states = f
	end
	def process(s)
		q = @initial_state
		s.each_char { |c| q = @transitions[q][c] }
		@final_states.include? q
	end
	def combine(fsm)
		nstates = @states.product fsm.states
		nalphabet = (fsm.alphabet + @alphabet).uniq # If they are different all hell breaks loose
		ntransitions = Hash.new { |hash, key| hash[key] = Hash.new }
		nstates.product(nalphabet).map do |qs, c|
			ntransitions[qs][c] = [@transitions[qs[0]][c], fsm.transitions[qs[1]][c]]
		end
		ninitial_state = [@initial_state, fsm.initial_state]
		nfinal_states = @final_states.product fsm.final_states
		FiniteStateMachine.new nstates, nalphabet, ntransitions, ninitial_state, nfinal_states
	end
	def union(fsm)
		combine(fsm)
	end
	def intersection(fsm)
		nfsm = combine(fsm)
		# filter final states
		#nfsm.final_states.select! { |s|  }
		nfsm
	end
	def to_s
		lines = Array.new
		lines.push "States:"
		lines.push @states.map { |s| "\tq%s" % s.to_s }
		lines.push "Alphabet:"
		lines.push "\t%s" % @alphabet.zip(Array.new(@alphabet.length - 1, ",")).to_s
		lines.push "Transitions:"
		@transitions.keys.sort.each do |k|
			@alphabet.each do |l|
				lines.push "\tq%s -%s-> q%s" % [k, l, @transitions[k][l]] 
			end
		end
		lines.push "initial_state state:"
		lines.push "\tq%s" % @initial_state.to_s
		lines.push "Final states:"
		lines.push @final_states.map { |s| "\tq%s" % s.to_s }
		lines.join "\n"
	end
end