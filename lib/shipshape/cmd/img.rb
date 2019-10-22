# frozen_string_literal: true

require 'thor'
require 'json'
require 'English'

module Shipshape
  class Img < Thor
    include ::Thor::Actions

    desc 'build IMAGE_VERSION',
         'Build and tag docker image. Used in combination with "img push" to send img to ECR. ' \
         'Uses docker-compose files in the current directory.'
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
      statuses = run_status
      remote_img_build_cmd = "IMAGE_VERSION=#{image_version} " \
                             "docker-compose -f #{options['docker_build_yml']} build --force-rm"
      run remote_img_build_cmd unless options['local']
      statuses += run_status
      raise 'Problem building docker images' if statuses.positive?
    end

    desc 'push APP_NAME IMAGE_VERSION REMOTE_IMAGE_VERSION',
         'Tag and push docker image to ECR. Authenticates using AWS credentials in env or ~/.aws/credentials.'
    option :registry_host,
           default: '368304857153.dkr.ecr.us-east-1.amazonaws.com',
           aliases: %w[-h --registry-host],
           desc: 'ECR host DNS.'

    def push(app_name, image_version, remote_image_version)
      path = Pathname(__FILE__).join('../../../../bin/push_img').expand_path
      run "#{path} #{app_name} #{image_version} #{remote_image_version} #{options['registry_host']}"
      raise 'Problem pushing docker images' if run_status.positive?
    end

    private

    def run_status
      $CHILD_STATUS.exitstatus
    end
  end
end
