# frozen_string_literal: true

require 'thor'
require 'json'

module Shipshape
  class Bootstrap < Thor::Group
    include Thor::Actions

    source_root Pathname(File.expand_path('..', __FILE__)).dirname

    def add_files
      directory('templates', Pathname('.').expand_path)
    end
  end
end
