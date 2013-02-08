# encoding: utf-8
require File.expand_path('../lib/rankeable/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name = 'rankeable'
  spec.version = Rankeable::VERSION
  spec.authors = ["Runtime Revolution"]
  spec.description = %q{A Rankeable is a rankings rule system for Rails Applications}
  spec.files = Dir.glob("lib/**/*.rb")
  spec.require_paths = ['lib']
  spec.required_rubygems_version = Gem::Requirement.new('>= 1.3.6')
  spec.summary = spec.description
  spec.test_files = Dir.glob("spec/**/*")

  spec.add_dependency('rails', '>= 3.0')

  spec.add_development_dependency('rspec')
  spec.add_development_dependency('factory_girl')
  spec.add_development_dependency('database_cleaner')
  spec.add_development_dependency('sqlite3')
end