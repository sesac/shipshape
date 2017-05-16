# coding: utf-8
# frozen_string_literal: true

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'shipshape/version'

Gem::Specification.new do |spec|
  spec.name          = 'shipshape'
  spec.version       = Shipshape::VERSION
  spec.authors       = ['Ian MacDonald']
  spec.email         = ['imacdonald@rumblefish.com']

  spec.summary       = %(Toolkit for building and deploying applications)
  spec.description   = %(Abstract the general patterns we use to deploy application)
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against ' \
      'public gem pushes.'
  end

  spec.files = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'codeclimate-test-reporter'
  spec.add_dependency 'rspec_junit_formatter'
  spec.add_dependency 'thor'
  spec.add_dependency 'aws-sdk'
  spec.add_dependency 'octokit'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
