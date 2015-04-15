# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'holidays/version'

Gem::Specification.new do |gem|
  gem.name          = 'holidays'
  gem.version       = Holidays::VERSION
  gem.authors       = ['Alex Dunae']
  gem.email         = ['code@dunae.ca']
  gem.homepage      = 'https://github.com/alexdunae/holidays'
  gem.description   = %q(A collection of Ruby methods to deal with statutory and other holidays. You deserve a holiday!)
  gem.summary       = %q(A collection of Ruby methods to deal with statutory and other holidays.)
  gem.files         = `git ls-files`.split("\n") - ['.gitignore', '.travis.yml']
  gem.test_files    = gem.files.grep(/^test/)
  gem.require_paths = ['lib']
  gem.licenses      = ['MIT']
  gem.add_runtime_dependency('when_easter', '~> 0.3.1')
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rake'
end
