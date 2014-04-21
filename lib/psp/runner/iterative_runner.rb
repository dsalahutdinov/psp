# coding: utf-8
require 'active_support/core_ext/object/try'

module Psp
  class Runner
    class IterativeRunner
      def initialize(collection)
        @collection = Array.wrap(collection)
      end

      def run(context)
        succeed = @collection.collect do |element|
          puts "Run \e[0;32m#{extract_name(element)}\e[0m"

          system("#{context.env} bundle exec rspec #{element} 2>&1")
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
