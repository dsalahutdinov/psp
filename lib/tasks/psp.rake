require 'psp'

namespace :psp do
  desc 'Run all specs in parallel mode'
  task :all do
    tasks = Psp::PathResolver.new(
      plugins: Psp::PathResolver::DEFAULT_PATH_MASK,
      project: Psp::PathResolver::DEFAULT_PATH_MASK).expand

    succeed = Psp::Runner.new(tasks, concurrency: ENV.fetch('JOBS', 5)).run

    exit(succeed ? 0 : 1)
  end
end
