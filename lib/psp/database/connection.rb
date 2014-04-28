# coding: utf-8
require 'active_record'

module Psp
  module Database
    module Connection
      include Output
      include Ascii

      extend self

      MAX_TIMEOUT_RETRIES = 5

      def establish!
        verbose { puts "Connecting to #{green database_name} database" }

        ActiveRecord::Base.establish_connection(Configuration.system)
      end

      def current
        ActiveRecord::Base.connection
      end

      def with_connection
        ActiveRecord::Base.connection_pool.with_connection do
          yield
        end
      rescue ActiveRecord::ConnectionTimeoutError
        restarts ||= 0
        if (restarts += 1) < MAX_TIMEOUT_RETRIES
          sleep 1
          retry
        else
          raise
        end
      end

      private
      def database_name
        Configuration.system['database']
      end
    end # module Connection
  end # module Database
end # module Psp
