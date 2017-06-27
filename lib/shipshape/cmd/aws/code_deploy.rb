# frozen_string_literal: true

require 'thor'
require_relative 'code_deploy/deploy'

module Shipshape
  class AWS
    class CodeDeploy < Thor
      register(Deploy, 'deploy', 'deploy', 'Deploy application via CodeDeploy')
      tasks['deploy'].options = Deploy.class_options
    end
  end
end
