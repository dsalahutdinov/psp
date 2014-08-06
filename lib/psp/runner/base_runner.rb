# coding: utf-8
module Psp
  class Runner
    class BaseRunner
      include Output
      include Ascii

      def initialize(collection, options)
        @collection = Array.wrap(collection)

        @profile = options.fetch(:profile, false)
      end

      def run(context)
        raise NoMethodError
      end

      private

      def stderr_to_stdout
        "2>&1#{' 1>/dev/null' unless Output.verbose?}"
      end

      def rspec_options
        opts = []
        opts << '--profile --' if @profile
        opts.join(' ')
      end
    end
  end
end