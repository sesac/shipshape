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
          client = new_client
          result = parse_source(source) { |line|
            [client.encrypt(key_id: options['kms_key_id'], plaintext: line).ciphertext_blob].pack('*m').delete("\n")
          }

          write_result(destination, result)
        end

        def decrypt_object(source, destination)
          client = new_client
          result = parse_source(source) { |line|
            client.decrypt(ciphertext_blob: line.unpack('*m').first).plaintext
          }

          write_result(destination, result)
        end

        class << self
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

        private

        def new_client
          Aws::KMS::Client.new
        end

        def parse_source(source)
          Pathname(source).expand_path.readlines.lazy.collect(&:chomp).collect { |line|
            next line if line.length <= 1

            yield line
          }
        end

        def write_result(destination, result)
          Pathname(destination).expand_path.open('w') { |file| write_content(file, result) }
        end

        def write_content(file, content)
          content.each { |line| file.write(line + "\n") }
        end
      end
    end
  end
end
