# frozen_string_literal: true

require 'thor'
require_relative './cmd/aws/simple_storage_service'
require_relative './cmd/aws/key_management_service'
require_relative './cmd/aws/code_deploy'
require_relative './cmd/coverage'
require_relative './cmd/bootstrap'
require_relative './cmd/env'
require_relative './cmd/img'
require_relative './cmd/github/status'

module Shipshape
  class Cmd < Thor
    desc 's3 SUBCOMMAND ...ARGS', 'AWS S3 tasks'
    subcommand 's3', AWS::SimpleStorageService

    desc 'kms SUBCOMMAND ...ARGS', 'AWS KMS tasks'
    subcommand 'kms', AWS::KeyManagementService

    desc 'codedeploy SUBCOMMAND ...ARGS', 'CodeDeploy tasks'
    subcommand 'codedeploy', AWS::CodeDeploy

    desc 'coverage SUBCOMMAND ...ARGS', 'Formatting coverage'
    subcommand 'coverage', Coverage

    desc 'github SUBCOMMAND ...ARGS', 'Github repo tasks'
    subcommand 'github', Github

    desc 'env SUBCOMMAND ...ARGS', '.env tasks'
    subcommand 'env', Env

    desc 'img SUBCOMMAND ...ARGS', 'Docker image tasks. Mainly for interacting with ECR.'
    subcommand 'img', Img

    register(Bootstrap, 'bootstrap', 'bootstrap', 'Add files to project to assist with deployment')
  end
end
