# coding: utf-8
require 'thread'

module Psp
  module MutexPool
    extend self

    MUTEXES = {
      postgresql: Mutex.new,
      configurations:  Mutex.new,
      database_context: Mutex.new
    }.freeze

    def [](key)
      MUTEXES.fetch(key)
    end
  end # module MutexPool
end # module Psp
