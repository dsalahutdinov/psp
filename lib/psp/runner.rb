# coding: utf-8
require 'parallel'
require 'active_support/core_ext/array'
require 'active_support/core_ext/hash'

module Psp
  class Runner
    def initialize(collection, options = Hash.new)
      Output.setup(verbose: options.delete(:verbose))

      @runner_options = options.slice(:profile)

      @dry_run = options.delete(:dry_run)

      @manager = Manager.new(collection, options)
      @manager.plugin_runner = IterativeRunner
      @manager.project_runner = BulkRunner
    end

    def run
      puts "Concurrency: #{@manager.print_concurrency}"
      puts "Runners: #{@manager.print_runners_count}"
      puts "Allocation: #{@manager.print_runners_allocation}"

      return true if dry_run?

      #Database::Connection.establish!
      succeed = Parallel.map(@manager.allocation, in_threads: @manager.concurrency) do |(batch, runner)|
        in_database_context do |context|
          runner.new(batch, @runner_options).run(context)
        end
      end

      succeed.all?
    end

    private
    def dry_run?
      !!@dry_run
    end

    def in_database_context(&block)
      context = Database::Context.new(templates: ['test', 'test_orders'])
      context.execute { |x| block[x] }
    end
  end # class Runner
end # module Psp
