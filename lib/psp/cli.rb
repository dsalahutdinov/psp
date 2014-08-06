# coding: utf-8
require 'optparse'

module Psp
  class Cli
    def initialize(argv)
      @argv = argv
    end

    def run
      option_parser = create_option_parser
      option_parser.parse!(@argv)

      tasks = PathResolver.new(@runner_tasks).expand
      succeed = Runner.new(tasks, @runner_options).run
      exit_code = boolean_to_exit_code(succeed)

      puts "Total exit code: #{exit_code}"
      exit(exit_code)
    rescue OptionParser::ParseError
      puts 'Error: wrong usage. See help.'
      puts option_parser.help
      exit
    end

    private
    def boolean_to_exit_code(boolean)
      boolean ? 0 : 1
    end

    def create_option_parser
      OptionParser.new do |parser|
        @runner_tasks = Hash.new
        @runner_options = Hash.new

        parser.banner = "Parallel specs\nUsage: psp [options]"
        parser.version = VERSION

        parser.on('-p', '--project', 'Run all project specs') do
          @runner_tasks[:project] = PathResolver::DEFAULT_PATH_MASK
        end

        parser.on('-g', '--plugins', 'Run all plugins specs') do
          @runner_tasks[:plugins] = PathResolver::DEFAULT_PATH_MASK
        end

        parser.on('-l', '--plugin=<plugin1,...>', Array, 'Run specified plugins specs') do |plugins|
          @runner_tasks[:plugins] = plugins
        end

        parser.on('-j', '--jobs=<concurrency>', Integer, 'Set runner concurrency') do |concurrency|
          @runner_options[:concurrency] = concurrency
        end

        parser.on('--dry-run', 'Check out the allocations') do
          @runner_options[:dry_run] = true
        end

        parser.on('-v', '--verbose', 'Turn on verbosity') do
          @runner_options[:verbose] = true
        end

        parser.on('-r', '--profile', 'Show rspec profile summary') do
          @runner_options[:profile] = true
        end

        parser.on_tail('--version', 'Display the version') do
          puts parser.version
          exit
        end

        parser.on_tail('-h', '--help', 'You are looking at it') do
          puts parser.help
          exit
        end
      end
    end
  end  # class Cli
end # module Psp
