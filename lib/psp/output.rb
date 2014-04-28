# coding: utf-8

module Psp
  module Output
    class << self
      def setup(options)
        @verbose = options.fetch(:verbose, false)
      end

      def verbose?
        !!@verbose
      end
    end

    module_function
    def verbose
      yield if Output.verbose?
    end
  end # module Output
end # module Psp
