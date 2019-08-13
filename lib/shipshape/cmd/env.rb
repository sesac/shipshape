# frozen_string_literal: true

require 'thor'
require 'json'
require_relative '../actions/aws/parameter_store'

module Shipshape
  class Env < Thor
    include ::Thor::Actions
    include Actions::AWS::ParameterStore

    attr_reader :prefix

    desc 'push APP_NAME APP_ENV',
         'Push values in .env file to AWS Parameter Store. ' \
         'Authenticates using AWS credentials in env or ~/.aws/credentials.'

    def push(*args)
      @prefix = Prefix.new(*args)
      put_parameters(prefix, *exist_locally)
    end

    desc 'pull APP_NAME APP_ENV',
         'Pull values from parameter store into .env file.' \
         'Authenticates using AWS credentials in env or ~/.aws/credentials.'

    def pull(*args)
      @prefix = Prefix.new(*args)
      env_file.write(modified_locals)
    end

    private

    class Prefix < DelegateClass(String)
      attr_reader :app_name, :app_env

      def initialize(app_name, app_env)
        @app_name = app_name
        @app_env = app_env
        super(File.join('/', app_env, app_name))
      end
    end

    def env_file
      path = Pathname(".env.#{prefix.app_env}").expand_path
      path.write('') unless path.exist?

      path
    end

    def exist_locally
      local_params - remote_params
    end

    def modified_locals
      remote = exist_remotely

      (env_file.readlines.map(&:chomp).map { |line|
        next line unless (match = line.match(/^([A-Z]+[_A-Z]*)=(.*)/))

        key = match[1]
        val = remote.delete(key) { |*| match[2] }
        "#{key}=#{val}"
      } + remote.map { |key, val| "#{key}=#{val}" }).join("\n")
    end

    def exist_remotely
      (remote_params - local_params).map { |param_obj|
        [param_obj[:name].split('/').last, param_obj[:value]]
      }.to_h
    end

    def local_params
      Dotenv.parse(env_file.basename.to_s).map { |key, val| { name: File.join(prefix, key), value: val } }
    end

    def remote_params
      get_parameters(prefix)
    end
  end
end
