# coding: utf-8
require 'active_support/core_ext/object/try'

module Psp
  class Runner
    class IterativeRunner < BaseRunner
      def run(context)
        succeed = @collection.collect do |element|
          puts "Run #{green extract_name(element)}"

          result = !!system("#{context.env} bundle exec rspec #{rspec_options} #{element} #{stderr_to_stdout}")

          if result
            puts "Finished #{blue extract_name(element)}"
          else
            puts red("Finished #{extract_name(element)} with error")
          end

          result
        end

        succeed.all?
      end

      private

      def extract_name(element)
        element.match(/(?<name>[\w\_\-]+)\/spec$/)
          .try(:[], :name) || File.basename(element, '.rb')
      end
    end # PluginsRunner
  end # Runner
end # Psp
