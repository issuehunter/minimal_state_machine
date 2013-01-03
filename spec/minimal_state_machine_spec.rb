require 'spec_helper'

ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'msm_states'")
ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS 'state_machines'")
ActiveRecord::Base.connection.create_table(:msm_states) do |t|
  t.string :type
  t.references :state_machine, :polymorphic => true  
  t.timestamps
end

ActiveRecord::Base.connection.create_table(:state_machines)

class StateMachine < ActiveRecord::Base
  include MinimalStateMachine

  def self.states
    { :open => StateMachineOpen, :closed => StateMachineClosed, :solved => StateMachineSolved }
  end

  def self.initial_state
    'open'
  end
end

class StateMachineOpen < MinimalStateMachine::State
  def self.valid_transition_states
    %w(closed)
  end
end

class StateMachineClosed < MinimalStateMachine::State
  def self.valid_transition_states
    %w(solved open)
  end
end

class StateMachineSolved < MinimalStateMachine::State; end

describe StateMachine do
  before(:each) do
    @state_machine = StateMachine.create
  end

  it 'sets the initial state' do
    @state_machine.state.should be_a(StateMachineOpen)
  end

  it 'changes state' do
    @state_machine.state_name = 'closed'

    @state_machine.state.should be_a(StateMachineClosed)
  end

  it 'raises an invalid transition error if the new state is not among the allowed transition states' do
    expect { @state_machine.state_name = 'solved' }.to raise_error('MinimalStateMachine::InvalidTransitionError')
  end

  it 'raises an invalid state error if the state assigned in not among the allowed states' do
    expect { @state_machine.state_name = 'invalid_state' }.to raise_error('MinimalStateMachine::InvalidStateError')
  end
end