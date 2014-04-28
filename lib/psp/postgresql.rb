# coding: utf-8

module Psp
  module Postgresql
    include Output
    include Ascii

    extend self

    def version
      return @pg_version if defined?(@pg_version)

      MutexPool[:postgresql].synchronize do
        return @pg_version if defined?(@pg_version)

        verbose { puts "Gathering #{green 'PostgreSQL'} version" }
        @pg_version = %x{$(which psql) --version}.match(/\d+\.\d+/)[0].to_f
      end
    end
  end # module Postgresql
end # module Psp
