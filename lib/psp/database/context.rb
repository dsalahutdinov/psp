# coding: utf-8

module Psp
  module Database
    class Context
      attr_reader :env
      attr_reader :seed

      ENV_NAME = 'TEST_DATABASE_POSTFIX'.freeze
      ENV_TEMPLATE = "#{ENV_NAME}=_%i".freeze

      # options - Hash
      #           :template - String template database name (required)
      #           :seed     - Fixnum unique identifier of your context (optional)
      def initialize(options, &block)
        @template = options.fetch(:template)
        @seed = "#{Process.pid}#{options.fetch(:seed, generate_seed).to_i}"

        @env = (ENV_TEMPLATE % @seed).freeze
        @database = "#{@template}_#{@seed}".freeze

        execute(&block) unless block.nil?
      end

      def execute(&block)
        terminate_backends
        create_database

        block.call(self)
      ensure
        drop_database
      end

      private
      def create_database
        puts Ascii.yellow "SQL => CREATE DATABASE #{@database}"

        Connection.with_connection do
          Connection.current.execute <<-SQL
            DROP DATABASE IF EXISTS #{@database};
          SQL

          Connection.current.execute <<-SQL
            CREATE DATABASE #{@database}
            WITH TEMPLATE = #{@template};
          SQL
        end
      end

      def drop_database
        puts Ascii.yellow "SQL => DROP DATABASE #{@database}"

        Connection.with_connection do
          Connection.current.execute <<-SQL
            DROP DATABASE IF EXISTS #{@database};
          SQL
        end
      end

      def terminate_backends
        pid_column = (Postgresql.version < 9.2) ? 'procpid' : 'pid'

        Connection.with_connection do
          Connection.current.execute <<-SQL
            SELECT pg_terminate_backend(#{pid_column})
            FROM pg_stat_activity
            WHERE datname = #{Connection.current.quote @template};
          SQL
        end
      end

      def generate_seed
        MutexPool[:database_context].synchronize do
          return @@seed = 0 unless defined?(@@seed)
          @@seed += 1
        end
      end
    end # class Context
  end # module Database
end # module Psp
