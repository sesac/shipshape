# frozen_string_literal: true

require 'aws-sdk-s3'
require 'aws-sdk-kms'
require_relative '../aws/key_management_service'

module Shipshape
  module Actions
    module AWS
      module SimpleStorageService
        def self.included(mod)
          mod.class_option(*encrypt_options)
          mod.class_option(*KeyManagementService.kms_key_id_options)
          mod.class_option(*bucket_options)
        end

        def put_object(source, destination)
          Pathname(source).open { |file|
            new_client.put_object(bucket: options[:bucket], key: destination.to_s, body: file)
          }
        end

        def get_object(source, destination)
          new_client.get_object(bucket: options[:bucket], key: source, response_target: destination)
        end

        class << self
          def encrypt_options
            [
              :encrypt,
              type: :boolean,
              default: false,
              aliases: %w[-e --e],
              desc: 'Whether or not to encrypt/unencrypt the specified S3 object'
            ]
          end

          def bucket_options
            [
              :bucket,
              type: :string,
              default: ENV.fetch('AWS_DEFAULT_BUCKET', 'hub-code-deploy'),
              aliases: %w[-B --B --bucket],
              desc: 'The bucket to upload/download objects to/from. '\
                    'Can also be set with AWS_DEFAULT_BUCKET'
            ]
          end
        end

        private

        def new_client
          client = Aws::S3::Client.new

          options[:encrypt] and client = wrap_with_encryption_client(client)

          client
        end

        def wrap_with_encryption_client(s3_client)
          kms_client = Aws::KMS::Client.new

          Aws::S3::Encryption::Client.new(
            client:     s3_client,
            kms_key_id: options[:kms_key_id],
            kms_client: kms_client
          )
        end
      end
    end
  end
end
