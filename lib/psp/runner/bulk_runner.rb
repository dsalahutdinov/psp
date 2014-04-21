# coding: utf-8

module Psp
  class Runner
    class BulkRunner
      def initialize(collection)
        @collection = Array.wrap(collection)
      end

      def run(context)
        puts "Run \e[0;32m#{extract_name}\e[0m"

        !!system("#{context.env} bundle exec rspec #{@collection * ' '} 2>&1")
      end

      def extract_name
        "files (#{@collection.count})"
      end
    end # ProjectRunner
  end # Runner
end # Psp
