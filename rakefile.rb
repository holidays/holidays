$:.unshift File.expand_path('../lib', __FILE__)
require 'rake'
require 'rake/testtask'
require 'rdoc/task'
require 'yaml'
require 'fileutils'
require 'holidays'
require File.expand_path('data/build_defs')

task :default => :test

desc 'Run all tests'
task :test => ["test:lib", "test:defs"]

namespace :test do
  desc 'Run the unit tests.'
  Rake::TestTask.new(:defs) do |t|
    t.libs << 'lib'
    t.test_files = FileList['test/defs/test*.rb'].exclude('test_helper.rb')
    t.verbose = false
  end

  desc 'Run the definition tests.'
  Rake::TestTask.new(:lib) do |t|
    t.libs << 'lib'
    t.test_files = FileList['test/test*.rb'].exclude('test_helper.rb')
    t.verbose = false
  end
end

task :doc => ["defs:manifest", :rdoc]

desc 'Generate documentation.'
RDoc::Task.new do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'Ruby Holidays Gem'
  rdoc.options << '--all' << '--inline-source' << '--line-numbers'
  rdoc.options << '--charset' << 'utf-8'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('data/SYNTAX.rdoc')
  rdoc.rdoc_files.include('lib/holidays/MANIFEST')
  rdoc.rdoc_files.include('REFERENCES')
  rdoc.rdoc_files.include('CHANGELOG.rdoc')
  rdoc.rdoc_files.include('LICENSE')
  rdoc.rdoc_files.include('lib/*.rb')
end

desc 'Definition file tasks'
namespace :defs do
  DATA_PATH = 'data'

  desc 'Build holiday definition files'
  task :build_all do
    # load the index
    def_index = YAML.load_file("#{DATA_PATH}/index.yaml")

    # create a dir for the generated tests
    FileUtils.mkdir_p('test/defs')

    def_index['defs'].each do |region, files|
      puts "Building #{region} definition module:"
      files = files.collect { |f| "#{DATA_PATH}/#{f}" }
      files.uniq!

      module_src, test_src = parse_holiday_defs(region, files)
      File.open("lib/holidays/#{region.downcase.to_s}.rb","w") do |file|
        file.puts module_src
      end
      unless test_src.empty?
        File.open("test/defs/test_defs_#{region.downcase.to_s}.rb","w") do |file|
          file.puts test_src
        end
      end
      puts "Done.\n\n"
    end
  end

  desc 'Build the definition manifest.'
  task :manifest do
    File.open("lib/holidays/MANIFEST","w") do |file|
      file.puts <<-EOH
==== Regional definitions
The following definition files are included in this installation:

  EOH
      FileList.new('lib/holidays/*.rb').each do |str|
        file.puts('* ' + str.gsub(/^lib\/|\.rb$/, ''))
      end
    end
  end
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "holidays"
    gemspec.summary = "A collection of Ruby methods to deal with statutory and other holidays.  You deserve a holiday!"
    gemspec.description = "A collection of Ruby methods to deal with statutory and other holidays.  You deserve a holiday!"
    gemspec.email = "code@dunae.ca"
    gemspec.homepage = "https://github.com/alexdunae/holidays"
    gemspec.version = Holidays::VERSION
    gemspec.authors = ["Alex Dunae"]
    gemspec.add_development_dependency 'rdoc', '>= 2.4.2'
  end
rescue LoadError
  puts "Jeweler not available. Install it with: gem install jeweler"
end
