# frozen_string_literal: true

require 'thor'
require 'octokit'

module Shipshape
  class Github < Thor
    class Status < Thor
      include Thor::Actions

      desc 'post STATE CONTEXT DESCRIPTION',
           'Update github repo commit status'
      option :owner,
             aliases: %(-O --O),
             desc: 'Github repository owner'
      option :repo,
             default: Pathname.pwd.basename.to_s,
             aliases: %(-R --R),
             desc: 'Github repository name'
      option :target_url,
             aliases: %(-U --U --target-url --target-uri),
             desc: 'Link to source of status'
      option :access_token,
             default: ENV['BUNDLE_GITHUB__COM'].split(':').first,
             aliases: %(-T --T --access-token),
             desc: 'OAuth token for access to Github'

      def post(state, context, description)
        git_sha = run('git rev-parse --verify HEAD', capture: true).chomp

        resp = client.create_status(
          "#{options[:owner]}/#{options[:repo]}", git_sha, state,
          context: context,
          description: description,
          target_url: options[:target_url]
        )
        binding.pry
      end

      private

      def client
        @client ||= Octokit::Client.new(access_token: options[:access_token])
      end
    end

    desc 'status SUBCOMMAND ...ARGS', 'Github status tasks'
    subcommand 'status', Status
    tasks['status'].options = Status.class_options
  end
end
