# frozen_string_literal: true

require 'thor'
require_relative './cmd/aws/simple_storage_service'
require_relative './cmd/aws/code_deploy'
require_relative './cmd/coverage'
require_relative './cmd/github/status'

module Shipshape
  class Cmd < Thor
    desc 's3 SUBCOMMAND ...ARGS', 'AWS S3 tasks'
    subcommand 's3', AWS::SimpleStorageService
    tasks['s3'].options = AWS::SimpleStorageService.class_options

    desc 'codedeploy SUBCOMMAND ...ARGS', 'CodeDeploy tasks'
    subcommand 'codedeploy', AWS::CodeDeploy
    tasks['codedeploy'].options = AWS::CodeDeploy.class_options

    desc 'coverage SUBCOMMAND ...ARGS', 'Formatting coverage'
    subcommand 'coverage', Coverage
    tasks['coverage'].options = Coverage.class_options

    desc 'github SUBCOMMAND ...ARGS', 'Github repo tasks'
    subcommand 'github', Github
    tasks['github'].options = Github.class_options
  end
end
