require 'active_record'

module MinimalStateMachine
  class State < ActiveRecord::Base
    self.table_name = 'msm_states'

    def self.valid_transition_states
      []
    end
    
    belongs_to :state_machine, :polymorphic => true
  end
end
