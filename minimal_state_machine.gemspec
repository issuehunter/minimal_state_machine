# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'minimal_state_machine/version'

Gem::Specification.new do |gem|
  gem.name          = "minimal_state_machine"
  gem.version       = MinimalStateMachine::VERSION
  gem.authors       = ["Matteo Depalo"]
  gem.email         = ["matteodepalo@gmail.com"]
  gem.description   = %q{A state machine for activerecord implemented with the state pattern}
  gem.summary       = %q{A state machine}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_dependency 'activerecord'
  gem.add_dependency 'activesupport'

  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'debugger'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'activerecord-sqlite3-adapter'
end
