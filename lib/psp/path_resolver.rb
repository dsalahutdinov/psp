# coding: utf-8
require 'active_support/core_ext/array'

module Psp
  class PathResolver
    DEFAULT_PATH_MASK = '**'.freeze

    def initialize(options)
      @project_paths, @plugins_paths = extract_paths(options)
    end

    def expand
      (resolve_project_paths  + resolve_plugins_paths).map do |directory|
        FileResolver.new(directory)
      end
    end

    private
    def resolve_project_paths
      @project_paths.flat_map do |path|
        Dir.glob(File.join(Psp::ROOT_PATH, 'spec'))
      end
    end

    def resolve_plugins_paths
      @plugins_paths.flat_map do |plugin|
        Dir.glob(File.join(Psp::ROOT_PATH, 'vendor', 'plugins', plugin, 'spec'))
      end
    end

    def extract_paths(options)
      return all_specs_paths unless
        options.key?(:project) || options.key?(:plugins)

      [Array.wrap(options.fetch :project, Array.new),
       Array.wrap(options.fetch :plugins, Array.new)]
    end

    def all_specs_paths
      [[DEFAULT_PATH_MASK], [DEFAULT_PATH_MASK]]
    end
  end # class PathResolver
end # module Psp
