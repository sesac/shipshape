# frozen_string_literal: true

require 'thor'
require 'json'
require_relative '../actions/aws/key_management_service'

module Shipshape
  class Env < Thor
    include ::Thor::Actions
    include Actions::AWS::KeyManagementService

    desc 'push APP_NAME APP_ENV',
         'Push values in .env file to AWS Parameter Store. ' \
         'Authenticates using AWS credentials in env or ~/.aws/credentials.'

    def push(app_name, app_env)
      key_id = options['kms_key_id'].split('/').last
      path = Pathname(__FILE__).join('../../../../bin/push_env').expand_path
      run "AWS_KMS_KEY_ID=#{key_id} #{path} #{app_name} #{app_env}"
    end

    desc 'pull APP_NAME APP_ENV',
         'Pull values from parameter store into .env file.' \
         'Authenticates using AWS credentials in env or ~/.aws/credentials.'

    def pull(app_name, app_env)
      path = Pathname(__FILE__).join('../../../../bin/pull_env').expand_path
      run "#{path} #{app_name} #{app_env}"
    end
  end
end
