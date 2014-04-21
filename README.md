# Psp

Command line utility for project and plugins spec running.

## Features

1. Fair parallelism: all specs running in real processes
2. KISS: all you should know is what you want to test
3. PP: pretty console output
4. This tool is made with love :heart:

## Installation

Add this line to your application's Gemfile:

    gem 'psp'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install psp

## Usage

From root of your project

    $ psp -h
    $ Parallel specs
    $ Usage: psp [options]
    $   -p, --project                    Run all project specs
    $   -g, --plugins                    Run all plugins specs
    $   -l, --plugin=<plugin1,...>       Run specified plugins specs
    $   -j, --jobs=<concurrency>         Set runner concurrency
    $       --dry-run                    Check out the allocations
    $       --version                    Display the version
    $   -h, --help                       You are looking at it

## Contributing

1. Fork it ( https://github.com/abak-press/psp/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
