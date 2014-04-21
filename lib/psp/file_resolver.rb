# coding: utf-8
module Psp
  class FileResolver
    DEFAULT_PROJECT_NAME = 'project'.freeze

    attr_reader :name, :directory

    def initialize(path)
      @path = path
      @directory = relative_path(path)
      @name = project? ? DEFAULT_PROJECT_NAME : extract_plugin_name(path)
    end

    def size
      files.count
    end

    def plugin?
      @directory.include? File.join('vendor', 'plugins')
    end

    def project?
      !plugin?
    end

    def files
      @files ||= Dir.glob(File.join(@path, '**', '*_spec.rb')).map do |full_path|
        relative_path(full_path)
      end
    end

    private
    def relative_path(full_path)
      Pathname.new(full_path)
        .relative_path_from(Pathname.new ROOT_PATH).to_s
    end

    def extract_plugin_name(path)
      path.match(/vendor\/plugins\/(?<name>[\w\_\-]+)\/spec$/)[:name]
    end
  end # class FileResolver
end # module Psp
