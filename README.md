# MinimalStateMachine

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'minimal_state_machine'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install minimal_state_machine

## Usage

Add to Gemfile:

```ruby
gem 'minimal_state_machine'
```

Run:

```ruby
bundle install
rails generate minimal_state_machine
rake db:migrate
```

## Quick Start

Let's say we have an Issue ActiveRecord model and we want to turn it into a state machine with 3 possible states: open, closed, solved

```ruby
class Issue < ActiveRecord::Base
  include MinimalStateMachine

  def self.states
    { :open => IssueState::Open, :closed => IssueState::Closed, :solved => IssueState::Solved }
  end

  def self.initial_state
    'open'
  end
end

class IssueState::Open < MinimalStateMachine::State
  def self.valid_transition_states
    %w(closed)
  end
end

class IssueState::Closed < MinimalStateMachine::State
  def self.valid_transition_states
    %w(solved open)
  end
end

class IssueState::Solved < MinimalStateMachine::State; end
```

As you can se we define the possible states with an Hash including both the state names and the classes representing the states.
We can provide an optional `initial_state` class method to indicate the initial state (the default value is the first of the keys in the states Hash)

What would happen with this configuration:

```ruby
Issue.new.state
=> #<IssueState::Open id: nil, type: "IssueState::Open", state_machine_id: nil, state_machine_type: "Issue", created_at: nil, updated_at: nil> 

issue = Issue.new
issue.save
issue.state_name = 'closed'
issue.state
=> #<IssueState::Closed id: nil, type: "IssueState::Closed", state_machine_id: nil, state_machine_type: "Issue", reated_at: "2013-01-03 19:13:31", updated_at: "2013-01-03 19:13:31"> 
```

If you try to change the state to a non valid state a `MinimalStateMachine::InvalidTransitionError` will be raised.
If you try to set the state to a non declared state a `MinimalStateMachine::InvalidStateError` will be raised.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request