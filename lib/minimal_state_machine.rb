require 'minimal_state_machine/version'
require 'minimal_state_machine/state'
require 'active_support'

module MinimalStateMachine
  extend ActiveSupport::Concern

  included do
    has_one :state, :as => :state_machine, :class_name => 'MinimalStateMachine::State'

    after_initialize :set_initial_state, :if => proc { state.nil? }

    def self.states
      {}
    end

    class InvalidStateError < StandardError; end

    def state_name=(state_name)
      raise InvalidStateError unless self.class.states.keys.map(&:to_s).include?(state_name)

      if state.nil? || state.new_record?
        self.state = self.class.states[state_name.to_sym].new
      else
        transition_to state_name
      end
    end

    private

    class InvalidTransitionError < StandardError; end

    def transition_to(state_name)
      if state.class.valid_transition_states.include?(state_name)
        state.destroy
        self.state = self.class.states[state_name.to_sym].new
      else
        raise InvalidTransitionError
      end
    end

    def set_initial_state
      if self.class.respond_to?(:initial_state) && self.class.initial_state
        self.state_name = self.class.initial_state
      else
        self.state_name = self.class.states.keys.map(&:to_s).first
      end
    end
  end
end
