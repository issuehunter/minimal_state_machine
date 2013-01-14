require 'active_record'

module MinimalStateMachine
  class State < ActiveRecord::Base
    self.table_name = 'msm_states'

    def self.valid_transition_states
      []
    end
    
    belongs_to :state_machine, :polymorphic => true

    def valid_transition_to?(state_name)
      self.class.valid_transition_states.include?(state_name)
    end

    def name
      state_machine_class.states.invert[self.class].to_s if state_machine_class.respond_to?(:states)
    end

    private

    def state_machine_class
      state_machine_type.constantize
    end
  end
end
