# coding: utf-8
require 'erb'
require 'yaml'

module Psp
  module Configuration
    include Output
    include Ascii

    extend self

    def system
      load unless defined?(@system)
      @system
    end

    def test
      load unless defined?(@test)
      @test
    end

    private
    def load
      return if defined?(@configurations)

      MutexPool[:configurations].synchronize do
        return if defined?(@configurations)

        verbose { puts "Loading #{green 'database.yml'} configuration" }

        erb = ERB.new(IO.read File.join(ROOT_PATH, 'config', 'database.yml')).result
        @configurations = YAML.load(erb).freeze

        @test = @configurations['test'].freeze
        @system = @test.merge(
          'database' => 'postgres',
          'schema_search_path' => 'public').freeze
      end
    end
  end # module Configuration
end # module Psp
