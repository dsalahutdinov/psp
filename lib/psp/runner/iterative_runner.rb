# coding: utf-8
require 'active_support/core_ext/object/try'

module Psp
  class Runner
    class IterativeRunner
      include Output
      include Ascii

      def initialize(collection)
        @collection = Array.wrap(collection)
      end

      def run(context)
        succeed = @collection.collect do |element|
          puts "Run #{green extract_name(element)}"

          result = system("#{context.env} bundle exec rspec #{element} #{stderr_to_stdout}")

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
      # FIXME : Дублирование
      def stderr_to_stdout
        "2>&1#{' 1>/dev/null' unless Output.verbose?}"
      end

      def extract_name(element)
        element.match(/(?<name>[\w\_\-]+)\/spec$/)
          .try(:[], :name) || File.basename(element, '.rb')
      end
    end # PluginsRunner
  end # Runner
end # Psp
