# Ahoy Matey!

'tis a treasure chest o' utilities that can be used t' deploy applications usin' a general pattern we 'ave developed
that works fer our crew. Use some or all o' it.

![Anchor](docs/anchor.png)

## Installation

```console
git clone <repo>
cd <repo>
bundle
gem build shipshape.gemspec
gem install shipshape-0.2.6.gem
```

## Usage

The `shipshape` executable should now be in your path thanks to `bundler`. You can run `shipshape help` to get more
detailed usage information for each of the subcommands.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can
also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the
version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags.

To invoke cli without installation, run `bundle exec ./exe/shipshape <command>`.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/sesac/shipshape. This project is
intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the
[Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The package is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

![Chest](docs/chest.jpg)
