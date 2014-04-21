# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'psp/version'

Gem::Specification.new do |spec|
  spec.name          = 'psp'
  spec.version       = Psp::VERSION
  spec.authors       = ['Strech (Sergey Fedorov)', 'Aelphy (Usvyatsov Mikhail)']
  spec.email         = ['strech_ftf@mail.ru', 'miha-usv@yandex.ru']
  spec.summary       = 'Parallel specs'
  spec.description   = 'Command line utility for project and plugins spec running'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  spec.require_paths = ['lib']

  # NOTE : Залочили из-за наших проектов
  spec.add_dependency 'activerecord', '~> 3.1'
  spec.add_dependency 'activesupport', '~> 3.1'
  spec.add_dependency 'parallel', '~> 0.9'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
end
