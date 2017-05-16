# frozen_string_literal: true

require 'thor'
require_relative '../../actions/aws/simple_storage_service'

module Shipshape
  class AWS
    class SimpleStorageService < Thor
      include Actions::AWS::SimpleStorageService

      desc 'push SOURCE DESTINATION',
           'Optionally encrypt then upload a local file to S3 bucket'
      def push(source, destination)
        put_object(source, destination)
      end

      desc 'pull SOURCE DESTINATION',
           'Download a file from an S3 bucket then optionally unencrypt it'
      def pull(source, destination)
        get_object(source, destination)
      end
    end
  end
end
