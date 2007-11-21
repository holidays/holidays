require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'fileutils'
require 'lib/holidays'
require 'csv'

desc 'Run the unit tests.'
Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.libs << 'lib/test'
  t.test_files = FileList['test/test*.rb'].exclude('test_helper.rb')
  t.verbose = false
end


desc 'Generate documentation.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'Ruby Holidays Gem'
  rdoc.options << '--all' << '--inline-source' << '--line-numbers'
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('REFERENCES')
  rdoc.rdoc_files.include('LICENSE')
  rdoc.rdoc_files.include('lib/*.rb')
  rdoc.rdoc_files.include('lib/holidays/*.rb')
end


spec = Gem::Specification.new do |s| 
  s.name = 'holidays'
  s.version = '0.9.0'
  s.author = 'Alex Dunae'
  s.homepage = 'http://code.dunae.ca/holidays'
  s.platform = Gem::Platform::RUBY
  s.description = <<-EOF
    A collection of Ruby methods to deal with statutory and other holidays.  You deserve a holiday!
  EOF
  s.summary = 'A collection of Ruby methods to deal with statutory and other holidays.  You deserve a holiday!'
  s.files = FileList["{lib}/**/*"].to_a
  s.test_files = Dir.glob('test/test_*.rb') 
  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'REFERENCES', 'LICENSE']
  s.rdoc_options << '--all' << '--inline-source' << '--line-numbers'
end

desc 'Build the gem.'
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_zip = true
  pkg.need_tar = true 
end 