# frozen_string_literal: true

require 'aws-sdk-kms'

module Shipshape
  module Actions
    module AWS
      module KeyManagementService
        def self.included(mod)
          mod.class_option(*kms_key_id_options)
        end

        def encrypt_object(source, destination)
          result = new_client.encrypt(key_id: options['kms_key_id'], plaintext: Pathname(source).read)

          Pathname(destination).write(result.ciphertext_blob)
        end

        def decrypt_object(source, destination)
          result = new_client.decrypt(ciphertext_blob: Pathname(source).read)

          Pathname(destination).write(result.plaintext)
        end

        private

        def new_client
          Aws::KMS::Client.new
        end

        class << self
          private

          def kms_key_id_options
            [
              :kms_key_id,
              type: :string,
              default: ENV['AWS_KMS_KEY_ID'],
              aliases: %w[-K --K --kms-key-id],
              desc: 'The id of the AWS KMS Key to use for encryption. '\
                    'Can also be set with AWS_KMS_KEY_ID'
            ]
          end
        end
      end
    end
  end
end
