class FiniteStateMachine
	attr_reader :states, :alphabet, :transitions, :initial_state
	attr_accessor :final_states
	
	def initialize(s, l, d, q0, f)
		@states = s
		@alphabet = l
		@transitions = d
		@initial_state = q0
		@final_states = f
	end
	
	def deterministic?
		all_transitions_defined = true
		@transitions.each do |k,t| 
			@alphabet.each do |c| 
				all_transitions_defined &= t.key? c
			end
		end
		!@alphabet.include?('e') && @transitions.size == @states.size && all_transitions_defined
	end
	
	def process s
		q = [@initial_state]
		
		s.each_char do |c|
			state_queue = Array.new(q)
			q.clear
			state_queue = add_epsilon_states state_queue
			state_queue.each {|sq| q.push @transitions[sq][c] if @transitions[sq].key? c}
		end
		
		q = add_epsilon_states q
		q.any? {|s| @final_states.include? s}
	end
	
	def union(fsm)
		nfsm = combine(fsm)
		nfsm.final_states = @final_states.product fsm.states
		@states.product(fsm.final_states).each {|c| nfsm.final_states.push c}
		nfsm.final_states.uniq!
		nfsm
	end
	
	def intersection(fsm)
		nfsm = combine(fsm)
		nfsm.final_states = @final_states.product fsm.final_states
		nfsm
	end
	
	def to_s
		lines = Array.new
		lines.push "States:"
		lines.push @states.map {|s| "\tq%s" % s.to_s}
		calphabet = @alphabet
		unless deterministic?
			calphabet.push 'e'
		end
		lines.push "Alphabet:"
		lines.push "\t%s" % calphabet.zip([","] * (calphabet.size-1)).to_s
		lines.push "Transitions:"
		@transitions.keys.sort.each do |k|
			calphabet.each do |l|
				lines.push "\tq%s -%s-> q%s" % [k, l, @transitions[k][l]] if @transitions[k].key? l
			end
		end
		lines.push "initial_state state:"
		lines.push "\tq%s" % @initial_state.to_s
		lines.push "Final states:"
		lines.push @final_states.map {|s| "\tq%s" % s.to_s}
		lines.join "\n"
	end
	
	private
	
	def add_epsilon_states(state_queue)
		unless deterministic?
			begin
				added_states = []
				state_queue.each do |a|
					added_states.push(@transitions[a]['e']) if @transitions[a].key? 'e'
				end
				size_before = state_queue.size
				state_queue += added_states
				state_queue.uniq!
				size_after = (state_queue.size)
			end while size_before < size_after
		end
		state_queue
	end
	
	def combine(fsm)
		nstates = @states.product fsm.states
		nalphabet = (fsm.alphabet + @alphabet).uniq # If they are different all hell breaks loose
		ntransitions = Hash.new {|hash, key| hash[key] = Hash.new}
		nstates.product(nalphabet).map do |qs, c|
			ntransitions[qs][c] = [@transitions[qs[0]][c], fsm.transitions[qs[1]][c]]
		end
		ninitial_state = [@initial_state, fsm.initial_state]
		FiniteStateMachine.new nstates, nalphabet, ntransitions, ninitial_state, nil
	end
end