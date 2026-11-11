# frozen_string_literal: true

source 'https://rubygems.org'

# Specify your gem's dependencies in shipshape.gemspec
gemspec

# prism 2.x ships precompiled gems that require Ruby >= 3.3, but the deploy
# workflows run on Ruby 2.7 and resolve without a lockfile. rubocop 0.x pulls
# prism in through rubocop-ast, so cap it at the last source-only release line.
gem 'prism', '< 2'
