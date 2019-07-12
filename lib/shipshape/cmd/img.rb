# frozen_string_literal: true

require 'thor'
require 'json'

module Shipshape
  class Img < Thor
    include ::Thor::Actions

    desc 'build IMAGE_VERSION',
         'Build and tag docker image. Used in combination with "img push" to send img to ECR.'
    option :local,
           default: false,
           type: :boolean,
           aliases: %w[-l],
           desc: 'Build and tag image for local use only. Default will build img for local and ECR.'
    option :docker_build_yml,
           default: 'docker-compose.build.yml',
           aliases: %w[-f --docker-build-yml],
           desc: 'Compose file for building non-local img.'

    def build(image_version)
      run 'docker-compose build --force-rm'
      remote_img_build_cmd = "IMAGE_VERSION=#{image_version} " \
                             "docker-compose -f #{options['docker_build_yml']} build --force-rm"
      run remote_img_build_cmd unless options['local']
    end

    desc 'push APP_NAME APP_ENV',
         'Push docker image to ECR.'

    def push(app_name, app_env)
      key_id = options['kms_key_id'].split('/').last
      path = Pathname(__FILE__).join('../../../../bin/push_env').expand_path
      run "AWS_KMS_KEY_ID=#{key_id} #{path} #{app_name} #{app_env}"
    end
  end
end
