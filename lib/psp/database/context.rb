# coding: utf-8

module Psp
  module Database
    class Context
      include Output
      include Ascii

      attr_reader :env
      attr_reader :seed

      ENV_NAME = 'TEST_DATABASE_POSTFIX'.freeze
      ENV_TEMPLATE = "#{ENV_NAME}=_%i".freeze

      # options - Hash
      #           :template - String template database name (required)
      #           :seed     - Fixnum unique identifier of your context (optional)
      def initialize(options, &block)
        @templates = options.fetch(:templates)
        @seed = "#{Process.pid}#{options.fetch(:seed, generate_seed).to_i}"

        @env = (ENV_TEMPLATE % @seed).freeze
        @databases = @templates.inject({}) do|h, t|
          h[t] = "#{Configuration.test_databases[t]['database']}_#{@seed}".freeze
          h
        end.freeze

        execute(&block) unless block.nil?
      end

      def execute(&block)
        terminate_backends
        create_database

        block.call(self)
      #ensure
        drop_database
      end

      private
      def create_database
        #binding.pry
        @templates.each do |template|
          database = @databases[template]
          template_database = Configuration.test_databases[template]['database']

          verbose { puts yellow "SQL => CREATE DATABASE #{database} from #{template_database}" }

          #Connection.with_connection(template) do
            Connection.execute_for template, <<-SQL
              DROP DATABASE IF EXISTS #{database};
            SQL

            Connection.execute_for template, <<-SQL
              CREATE DATABASE #{database}
              WITH TEMPLATE = #{template_database};
            SQL
          #end
        end
      end

      def drop_database
        #binding.pry
        @templates.each do |template|
        database = @databases[template]

          verbose { puts yellow "SQL => DROP DATABASE #{database}" }

          #Connection.with_connection(template) do
            Connection.execute_for template, <<-SQL
              DROP DATABASE IF EXISTS #{database};
            SQL
          #end
        end
      end

      def terminate_backends
        #binding.pry
        pid_column = (Postgresql.version < 9.2) ? 'procpid' : 'pid'

        @templates.each do |template|
          template_database = Configuration.test_databases[template]['database']
          database = @databases[template]
          #Connection.with_connection(template) do
            connection = Connection.connection_for(template)
            Connection.execute_for template, <<-SQL
              SELECT pg_terminate_backend(#{pid_column})
              FROM pg_stat_activity
              WHERE datname = #{connection.quote template_database};
            SQL
          #end
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
