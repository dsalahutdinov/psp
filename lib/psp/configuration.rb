# coding: utf-8
require 'erb'
require 'yaml'

module Psp
  module Configuration
    include Output
    include Ascii

    extend self

    def system_databases
      load unless defined?(@system_databases)
      @system_databases
    end

    def test_databases
      load unless defined?(@test_databases)
      @test_databases
    end

    private
    def load
      return if defined?(@configurations)

      MutexPool[:configurations].synchronize do
        return if defined?(@configurations)

        verbose { puts "Loading #{green 'database.yml'} configuration" }

        erb = ERB.new(IO.read File.join(ROOT_PATH, 'config', 'database.yml')).result
        @configurations = YAML.load(erb).freeze
        #binding.pry
        @test_databases = @configurations.freeze
        @system_databases = @test_databases.inject({}) do |h, (k, v)|
          h[k] = v.merge(
            'database' => 'postgres',
            'username' => 'postgres',
            'schema_search_path' => 'public').freeze
          h
        end

        #verbose { puts @test_databases.inspect }
        #verbose { puts @system_databases.inspect }
      end
    end
  end # module Configuration
end # module Psp
