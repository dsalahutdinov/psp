# coding: utf-8

module Psp
  class Runner
    class BulkRunner < BaseRunner
      def run(context)
        puts "Run #{green extract_name}"

        result = !!system("#{context.env} bundle exec rspec #{rspec_options} #{@collection * ' '} #{stderr_to_stdout}")

        if result
          puts "Finished #{blue extract_name}"
        else
          puts red("Finished #{extract_name} with error")
        end

        result
      end

      private

      def extract_name
        "files (#{@collection.count})"
      end
    end # ProjectRunner
  end # Runner
end # Psp
