# coding: utf-8

module Psp
  module Postgresql
    extend self

    def version
      return @pg_version if defined?(@pg_version)

      MutexPool[:postgresql].synchronize do
        return @pg_version if defined?(@pg_version)

        puts "Gathering \e[0;32mPostgreSQL\e[0m version"
        @pg_version = %x{$(which psql) --version}.match(/\d+\.\d+/)[0].to_f
      end
    end
  end # module Postgresql
end # module Psp
