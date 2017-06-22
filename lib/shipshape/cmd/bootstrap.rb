# frozen_string_literal: true

require 'thor'
require 'json'

module Shipshape
  class Bootstrap < Thor::Group
    include Thor::Actions

    # def self.source_root
    #   File.dirname(__FILE__)
    # end

    def create_lib_file
      dest = Pathname(__dir__).expand_path
      binding.pry
      directory('./lib/shipshape/templates', dest)
    end
  end
end
