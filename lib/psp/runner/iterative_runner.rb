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

          system("#{context.env} bundle exec rspec #{element} #{stderr_to_stdout}")
        end

        succeed.all?
      end

      private
      # FIXME : Дублирование
      def stderr_to_stdout
        Output.verbose? ? '2>&1' : '2>1'
      end

      def extract_name(element)
        element.match(/(?<name>[\w\_\-]+)\/spec$/)
          .try(:[], :name) || File.basename(element, '.rb')
      end
    end # PluginsRunner
  end # Runner
end # Psp
