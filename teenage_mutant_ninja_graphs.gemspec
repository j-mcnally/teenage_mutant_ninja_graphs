# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'teenage_mutant_ninja_graphs/version'

Gem::Specification.new do |gem|
  gem.name          = "teenage_mutant_ninja_graphs"
  gem.version       = TeenageMutantNinjaGraphs::VERSION
  gem.authors       = ["Justin McNally"]
  gem.email         = ["justin@kohactive.com"]
  gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{TODO: Write a gem summary}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
  gem.add_runtime_dependency "jquery-rails"
  gem.add_runtime_dependency "underscore-rails"
  gem.add_runtime_dependency "coffee-rails"
  gem.add_runtime_dependency "recurrence"
end
