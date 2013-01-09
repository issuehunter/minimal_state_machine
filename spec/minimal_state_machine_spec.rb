require 'spec_helper'

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
    @state_machine.save

    @state_machine.state.should be_a(StateMachineClosed)
  end

  it 'provides a human friendly getter for the state_name' do
    @state_machine.state_name.should == 'open'
  end

  it 'destroys the previous state after the transition' do
    @state_machine.state_name = 'closed'
    @state_machine.save

    MinimalStateMachine::State.count.should == 1
  end

  it 'raises an invalid transition error if the new state is not among the allowed transition states' do
    expect { @state_machine.state_name = 'solved' }.to raise_error('MinimalStateMachine::InvalidTransitionError')
  end

  it 'raises an invalid state error if the state assigned in not among the allowed states' do
    expect { @state_machine.state_name = 'invalid_state' }.to raise_error('MinimalStateMachine::InvalidStateError')
  end
end