# coding: utf-8
require 'psp/version'
require 'psp/mutex_pool'
require 'psp/postgresql'
require 'psp/configuration'
require 'psp/path_resolver'
require 'psp/file_resolver'
require 'psp/database'
require 'psp/database/connection'
require 'psp/database/context'
require 'psp/manager'
require 'psp/runner'
require 'psp/runner/bulk_runner'
require 'psp/runner/iterative_runner'
require 'psp/ascii' # NOTE : Дабы не привносить новых «полезных» гемов
require 'psp/railtie' if defined?(Rails)
require 'psp/cli'

module Psp
  ROOT_PATH = if defined?(Rails) && Rails.root.present?
    Rails.root.freeze
  else
    # FIXME : Хорошо бы как-то определять корень проекта.
    #         Но увы, это не очень реально, т.к ситуаций может быть много
    Dir.pwd.freeze
  end
end
