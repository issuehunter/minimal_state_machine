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

    @state_machine.should be_valid
    @state_machine.state.should be_a(StateMachineClosed)
  end

  it 'doesn\'t change state if new state is the same as current state' do
    @state_machine.state_name = 'open'
    @state_machine.save

    @state_machine.should be_valid
    @state_machine.state.should be_a(StateMachineOpen)
  end

  it 'should provide a human friendly getter for the state_name but it doesn\'t' do
    @state_machine.state_name.should eq('open')
    @state_machine = StateMachine.first
    @state_machine.state_name.should be_nil
  end

  it 'destroys the previous state after the transition' do
    @state_machine.state_name = 'closed'
    @state_machine.save

    expect { @state_machine.save }.not_to change { MinimalStateMachine::State.count }
  end

  it 'adds error if the new state is not among the allowed transition states' do
    @state_machine.state_name = 'solved'
    @state_machine.should_not be_valid
    @state_machine.errors[:state].should include('invalid transition from open to solved')
  end

  it 'raises an invalid state error if the state assigned in not among the allowed states' do
    expect { @state_machine.state_name = 'invalid_state' }.to raise_error('MinimalStateMachine::InvalidStateError')
  end
end