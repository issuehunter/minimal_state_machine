require 'minimal_state_machine/version'
require 'minimal_state_machine/state'
require 'active_support'

module MinimalStateMachine
  extend ActiveSupport::Concern

  included do
    has_one :state, :as => :state_machine, :class_name => 'MinimalStateMachine::State'

    after_initialize :set_initial_state, :if => proc { state.nil? }
    after_save :destroy_previous_state, :if => proc { previous_state && previous_state != state }

    validate do
      if previous_state && !previous_state.valid_transition_to?(state_name)
        self.errors.add(:state, "invalid transition from #{previous_state.name} to #{state_name}")
      end
    end

    attr_accessor :previous_state

    def self.states
      {}
    end

    class InvalidStateError < StandardError; end

    def state_name=(state_name)
      raise InvalidStateError unless self.class.states.keys.map(&:to_s).include?(state_name)
      
      transition_to(state_name)
    end

    def state_name
      state.name
    end

    private

    def transition_to(state_name)
      self.previous_state = state
      self.state = self.class.states[state_name.to_sym].new
    end

    def set_initial_state
      if self.class.respond_to?(:initial_state) && self.class.initial_state
        self.state_name = self.class.initial_state
      else
        self.state_name = self.class.states.keys.map(&:to_s).first
      end
    end

    def destroy_previous_state
      previous_state.destroy
    end
  end
end
