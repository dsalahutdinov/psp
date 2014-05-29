# coding: utf-8

module Psp
  class Runner
    class BulkRunner
      include Output
      include Ascii

      def initialize(collection)
        @collection = Array.wrap(collection)
      end

      def run(context)
        puts "Run #{green extract_name}"

        !!system("#{context.env} bundle exec rspec #{@collection * ' '} #{stderr_to_stdout}")
      end

      private
      # FIXME : Дублирование
      def stderr_to_stdout
        "2>&1#{' 1>/dev/null' unless Output.verbose?}"
      end

      def extract_name
        "files (#{@collection.count})"
      end
    end # ProjectRunner
  end # Runner
end # Psp
