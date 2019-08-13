# frozen_string_literal: true

require 'aws-sdk-ssm'
require_relative '../aws/key_management_service'
require_relative '../aws/simple_storage_service'

module Shipshape
  module Actions
    module AWS
      module ParameterStore
        def self.included(mod)
          mod.class_option(*KeyManagementService.kms_key_id_options)
          mod.class_option(*SimpleStorageService.encrypt_options)
        end

        def get_parameters(path)
          params = get_all_parameters(path.to_s)

          params.map { |param_obj| param_obj.to_h.select { |key,| %i[name value].include?(key) } }
        end

        def put_parameters(prefix, *params)
          params.each { |param|
            ssm_client.put_parameter(put_opts.merge(param))
            ssm_client.add_tags_to_resource(parameter_tags(param[:name], prefix))
          }
        end

        private

        def ssm_client
          @ssm_client ||= Aws::SSM::Client.new
        end

        def get_all_parameters(path)
          opts = { path: path, with_decryption: options['encrypt'] }
          first_res = ssm_client.get_parameters_by_path(**opts)
          params = first_res.parameters
          next_token = first_res.next_token
          while next_token
            next_res = ssm_client.get_parameters_by_path(**opts.merge(next_token: next_token))
            params += next_res.parameters
            next_token = next_res.next_token
          end

          params
        end

        def put_opts
          return default_opts.merge(encrypt_opts) if options['encrypt']

          default_opts
        end

        def default_opts
          {
            overwrite: true,
            type: 'String'
          }
        end

        def encrypt_opts
          {
            key_id: options['kms_key_id'],
            type: 'SecureString'
          }
        end

        def parameter_tags(resource_id, prefix)
          {
            resource_type: "Parameter",
            resource_id: resource_id,
            tags: [
              {
                key: prefix.app_env,
                value: "WORKLOAD_TYPE_TAG"
              },
              {
                key: prefix.app_name,
                value: "PROJECT_TAG"
              }
            ]
          }
        end
      end
    end
  end
end
