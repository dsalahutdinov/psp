# coding: utf-8
module Psp
  class Railtie < Rails::Railtie
    rake_tasks do
      load File.join('tasks', 'psp.rake')
    end
  end # Railtie
end # Psp
