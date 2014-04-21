# coding: utf-8
require 'active_support/core_ext/array'

# TODO : Провести рефакторинг. Класс получился слишком толстым
#        1. Отделить вывод от рассчетов
#        2. Раздилить рассчеты распределений
module Psp
  class Manager
    # FIXME : Коэффициенты подобраны опытным путем. Быть может есть вариант
    #         лучше?
    PROJECT_RUNNERS_RATE = 0.13
    PLUGINS_RUNNERS_RATE = 4.9
    DEFAULT_CONCURRENCY = 1

    attr_reader :concurrency

    def initialize(collection, options = Hash.new)
      @concurrency = options.fetch(:concurrency, DEFAULT_CONCURRENCY)
        .to_i.nonzero? || DEFAULT_CONCURRENCY

      @project, @plugins = separate(collection)

      # TODO : Напрашивается 2-а класса проектные раннеры и плагинные
      @pr_runners_count, @pl_runners_count = calculate_runners_count
      @pr_runners_alloc, @pl_runners_alloc = Array.new, Array.new
      @pr_runners_satiety, @pl_runners_satiety = 0, 0
    end

    def allocation
      return @allocation if defined?(@allocation)
      raise RuntimeError, 'Runners are not set' unless runner_classes_defined?

      @allocation = calculate_project_runners_allocation +
                    calculate_plugin_runners_allocation
    end

    def project_runner=(klass)
      @pr_runner_klass = klass
    end

    def plugin_runner=(klass)
      @pl_runner_klass = klass
    end

    def print_concurrency
      Ascii.green(@concurrency)
    end

    def print_runners_allocation
      allocation unless defined?(@allocation)

      [print_pr_runners_allocation,
       print_pl_runners_allocation] * ' + '
    end

    def print_runners_count
      [Ascii.blue(@pr_runners_count),
       Ascii.magenta(@pl_runners_count)] * ' + '
    end

    private
    def print_pr_runners_allocation
      empty = @pr_runners_count.zero? ? [Ascii.blue('0')]
        : print_empty_runners_allocation(@pr_runners_count, @pr_runners_satiety)

      (@pr_runners_alloc.map { |x| Ascii.blue(x) } + empty) * '/'
    end

    def print_pl_runners_allocation
      empty = @pl_runners_count.zero? ? [Ascii.magenta('0')]
        : print_empty_runners_allocation(@pl_runners_count, @pl_runners_satiety)

      (@pl_runners_alloc.map { |x| Ascii.magenta(x) } + empty) * '/'
    end

    def print_empty_runners_allocation(total, used)
      ((total - used).nonzero? || 1).times.map { Ascii.red "0" }
    end

    def runner_classes_defined?
      @pr_runner_klass && @pl_runner_klass
    end

    def calculate_project_runners_allocation
      return empty_project_runners_allocation if @pr_runners_count.zero?

      allocation = @project.flat_map(&:files)
                     .in_groups(@pr_runners_count, false)
                     .reject(&:empty?)

      allocation.map do |x|
        @pr_runners_alloc << x.count
        @pr_runners_satiety += x.count

        [x, @pr_runner_klass]
      end
    end

    def calculate_plugin_runners_allocation
      return empty_plugin_runners_allocation if @pl_runners_count.zero?

      allocation = @plugins.flat_map(&:directory)
                     .in_groups(@pl_runners_count, false)
                     .reject(&:empty?)

      allocation.map do |x|
        @pl_runners_alloc << x.count
        @pl_runners_satiety += x.count

        [x, @pl_runner_klass]
      end
    end

    def empty_plugin_runners_allocation
      @pl_runners_alloc = Array.new
      @pl_runners_satiety = 0

      Array.new
    end

    def empty_project_runners_allocation
      @pr_runners_alloc = Array.new
      @pr_runners_satiety = 0

      Array.new
    end

    def separate(collection)
      collection.reduce([[], []]) do |memo, resolver|
        memo[resolver.project? ? 0 : 1] << resolver
        memo
      end
    end

    def calculate_runners_count
      if @project.empty?
        [0, @concurrency]
      elsif @plugins.empty?
        [@concurrency, 0] # TODO : Добавить маленькие очереди и сюда!
      else
        project = (@concurrency * PROJECT_RUNNERS_RATE).ceil
        plugin = (@plugins.count / PLUGINS_RUNNERS_RATE).ceil

        [project, plugin]
      end
    end
  end # class Manager
end # module Psp
