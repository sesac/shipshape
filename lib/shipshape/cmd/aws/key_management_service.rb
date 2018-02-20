# frozen_string_literal: true

require 'thor'
require_relative '../../actions/aws/key_management_service'

module Shipshape
  class AWS
    class KeyManagementService < Thor
      include Actions::AWS::KeyManagementService

      desc 'encrypt SOURCE DESTINATION',
           'encrypt a file locally using KMS'
      def encrypt(source, destination)
        encrypt_object(source, destination)
      end

      desc 'decrypt SOURCE DESTINATION',
           'decrypt a file locally using KMS'
      def decrypt(source, destination)
        decrypt_object(source, destination)
      end
    end
  end
end
