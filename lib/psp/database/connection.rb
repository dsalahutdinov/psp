# coding: utf-8
require 'active_record'

module Psp
  module Database
    module Connection
      include Output
      include Ascii

      extend self

      MAX_TIMEOUT_RETRIES = 5

      def establish!(template)
        #binding.pry
        config = Configuration.system_databases[template]
        database_name = config['database']

        @connection_classes = {} if @connection_classes.nil?
        unless @connection_classes.key?(template)
          verbose { puts "Connecting to template" }
          @connection_classes[template] = Class.new(ActiveRecord::Base) do
            establish_connection config
          end
        end

        @connection_classes[template].establish_connection config
      end
      #
      # def current
      #   ActiveRecord::Base.connection
      # end

      def connection_for(template)
        establish!(template)
        @connection_classes[template].connection
      end

      def execute_for(template, sql)
        #verbose { puts "Execute #{template} sql: #{sql}" }
        connection_for(template).execute(sql)
      end

      # def with_connection(template)
      #   establish!(template)
      #   @connection_classes[template].connection
      #   ActiveRecord::Base.connection_pool.with_connection do
      #     yield
      #   end
      # rescue ActiveRecord::ConnectionTimeoutError
      #   restarts ||= 0
      #   if (restarts += 1) < MAX_TIMEOUT_RETRIES
      #     sleep 1
      #     retry
      #   else
      #     raise
      #   end
      # end
    end # module Connection
  end # module Database
end # module Psp
