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
        verbose { puts "Run #{green extract_name}" }

        !!system("#{context.env} bundle exec rspec #{@collection * ' '} #{stderr_to_stdout}")
      end

      private
      # FIXME : Дублирование
      def stderr_to_stdout
        Output.verbose? ? '2>&1' : '2>1'
      end

      def extract_name
        "files (#{@collection.count})"
      end
    end # ProjectRunner
  end # Runner
end # Psp
