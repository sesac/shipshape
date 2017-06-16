# frozen_string_literal: true

require 'thor'
require_relative '../../../actions/aws/simple_storage_service'

module Shipshape
  class AWS
    class CodeDeploy < Thor
      class Deploy < Thor::Group
        include Thor::Actions
        include Actions::AWS::SimpleStorageService

        class_option :source,
                     aliases: %w(-S --S),
                     desc: 'Source of application files to deploy',
                     default: './'

        class_option :application,
                     aliases: %w(-A --A),
                     desc: 'Name of CodeDeploy application to deploy',
                     default: Pathname.pwd.basename.to_s.upcase

        class_option :group,
                     aliases: %w(-G --G),
                     desc: 'Name of CodeDeploy application group',
                     default: "#{ENV.fetch('RACK_ENV', 'DEV').upcase}-#{Pathname.pwd.basename.to_s.upcase}"

        class_option :s3_location,
                     aliases: %w(-K --K -T --T --target --s3-target --s3-location),
                     desc: 'Key of the S3 object to upload project to for deployment. '\
                           'Will default to <application>/<group>/<application>.zip'

        desc 'Deploy application revision via AWS CodeDeploy'

        def zip_application
          @zip_location = Pathname("../#{Pathname.pwd.basename}.zip")
          run(%(zip -r "#{zip_location}" "#{options[:source]}" -x@.shipshapeignore))
        end

        def upload_revision
          @location = s3_location

          put_object(zip_location, location)
        end

        def create_deployment
          @client = Aws::CodeDeploy::Client.new

          @deploy_response = client.create_deployment(options_for_deployment)
        end

        def wait_for_deployment_to_complete
          client.wait_until(:deployment_successful, deployment_id: deploy_response.deployment_id)
        end

        private

        attr_reader :zip_location, :location, :client, :deploy_response

        def s3_location
          Pathname(options[:s3_location] ||
                   Pathname("#{options[:application].downcase}/"\
                            "#{options[:group].downcase}/"\
                            "#{zip_location.basename}"))
        end

        def options_for_deployment
          { application_name: options[:application],
            deployment_group_name: options[:group],
            ignore_application_stop_failures: true,
            revision: { revision_type: 'S3',
                        s3_location: { bucket: options[:bucket],
                                       key: location.to_s,
                                       bundle_type: 'zip' } } }
        end
      end

      register(Deploy, 'deploy', 'deploy', 'Deploy application via CodeDeploy')
      tasks['deploy'].options = Deploy.class_options
    end
  end
end
