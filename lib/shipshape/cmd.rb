# frozen_string_literal: true

require 'thor'
require_relative './cmd/aws/simple_storage_service'
require_relative './cmd/aws/code_deploy'
require_relative './cmd/coverage'
require 'pry'
binding.pry
require_relative './cmd/bootstrap'
require_relative './cmd/github/status'

module Shipshape
  class Cmd < Thor
    desc 's3 SUBCOMMAND ...ARGS', 'AWS S3 tasks'
    subcommand 's3', AWS::SimpleStorageService

    desc 'codedeploy SUBCOMMAND ...ARGS', 'CodeDeploy tasks'
    subcommand 'codedeploy', AWS::CodeDeploy

    desc 'coverage SUBCOMMAND ...ARGS', 'Formatting coverage'
    subcommand 'coverage', Coverage

    desc 'github SUBCOMMAND ...ARGS', 'Github repo tasks'
    subcommand 'github', Github

    register(Bootstrap, 'bootstrap', 'bootstrap', 'Add files to project to assist with deployment')
  end
end
