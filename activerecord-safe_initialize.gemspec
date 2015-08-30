# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_record/safe_initialize/version'

Gem::Specification.new do |spec|
  spec.name          = "activerecord-safe_initialize"
  spec.version       = ActiveRecord::SafeInitialize::VERSION
  spec.authors       = ["Adam Lassek"]
  spec.email         = ["alassek@lyconic.com"]
  spec.summary       = %q{Safely initialize an ActiveRecord attribute with respect to missing columns}
  spec.homepage      = "https://github.com/lyconic/activerecord-safe_initialize"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 3.1"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.3"
  spec.add_development_dependency "sqlite3"
end
