# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'holidays/version'

Gem::Specification.new do |gem|
  gem.name          = 'holidays'
  gem.version       = Holidays::VERSION
  gem.authors       = ['Alex Dunae', 'Hana Wang']
  gem.email         = ['code@dunae.ca', 'h.wang081@gmail.com']
  gem.homepage      = 'https://github.com/alexdunae/holidays'
  gem.description   = %q{A collection of Ruby methods to deal with statutory and other holidays. You deserve a holiday!}
  gem.summary       = %q{A collection of Ruby methods to deal with statutory and other holidays.}
  gem.test_files    = gem.files.grep(/^test/)
  gem.require_paths = ["lib"]
  gem.licenses      = ['MIT']
  gem.add_development_dependency 'bundler'
  gem.add_development_dependency 'rake'
end

