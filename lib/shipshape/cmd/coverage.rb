# frozen_string_literal: true

require 'thor'
require 'json'

module Shipshape
  class Coverage < Thor
    desc 'format SOURCE DESTINATION',
         'When running tests in docker, the filenames output by coverage tools don\'t map to files that exist on '\
         'the host file system. This munges the coverage results to be readable relative to the host machine.'
    option :coverage_root,
           default: '/var/app',
           aliases: %w(-C --C --coverage-root),
           desc: 'Path of the coverage relative to whatever container it was generated in'
    option :host_root,
           default: Dir.pwd,
           aliases: %w(-H --H --host-root),
           desc: 'Path relative to the host to change coverage to'

    def format(source, destination)
      @source      = Pathname(source)
      @destination = Pathname(destination)

      valid_input? or raise ArgumentError, "Must pass existing file/directory: #{source} does not exist."
      parse_results
      write_results
    end

    desc 'complete',
         'Retruns non-zero if code coverage is not 100%'
    def complete
      result = JSON.parse(Pathname('coverage/.last_run.json').read, symbolize_names: true)
      coverage = result.dig(:result, :covered_percent)

      raise ArgumentError, "Coverage less than 100%: #{coverage}" if coverage < 100
    end

    private

    attr_reader :source, :destination, :results

    def valid_input?
      source.exist?
    end

    def parse_results
      @results = JSON.parse(source.read)

      results.tap do |res|
        cov = res.dig('RSpec', 'coverage')
        res['RSpec']['coverage'] = cov.collect { |cov_key, cov_val|
          [cov_key.sub(options[:coverage_root], options[:host_root]), cov_val]
        }.to_h
      end
    end

    def write_results
      destination.dirname.mkpath

      destination.write(results.to_json)
    end
  end
end
