# frozen_string_literal: true

require 'thor'

module Shipshape
  class Github < Thor
    class Status < Thor
      include Thor::Actions

      desc 'post STATE CONTEXT DESCRIPTION',
           'Update github repo commit status'
      option :repo,
             default: Pathname.pwd.basename.to_s,
             aliases: %(-R --R),
             desc: 'Github repository name'
      option :build_url,
             aliases: %(-U --U --build-url --build-uri),
             desc: 'Link to source of status'
      option :github_access_token,
             default: ENV['BUNDLE_GITHUB__COM'],
             aliases: %(-T --T --access-token),
             desc: 'OAuth token for access to Github'
      def post(state, context, description)
        git_head = run('git rev-parse --verify HEAD')
        binding.pry
      end
    end

    desc 'status SUBCOMMAND ...ARGS', 'Github status tasks'
    subcommand 'status', Status
    tasks['status'].options = Status.class_options
  end
end
