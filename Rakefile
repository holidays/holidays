$:.unshift File.expand_path('../lib', __FILE__)
$:.unshift File.expand_path('../test', __FILE__)

require 'bundler/gem_tasks'
require 'rake/testtask'
require 'yaml'
require 'fileutils'
require 'holidays'

Rake::TestTask.new(:test) do |t|
  t.libs << 'test'
  t.test_files = FileList['test/**/test_*.rb']
end

task :default => :test

namespace :generate do
  DATA_PATH = 'data'
  TEST_DEFS_PATH = 'test/defs'

  desc 'Generate the holiday definition files'
  task :definitions do
    # load the index
    def_index = YAML.load_file("#{DATA_PATH}/index.yaml")

    # create a dir for the generated tests
    FileUtils.mkdir_p(TEST_DEFS_PATH)

    def_index['defs'].each do |region, files|
      puts "Building #{region} definition module:"
      files = files.collect { |f| "#{DATA_PATH}/#{f}" }.uniq

      module_src, test_src = Holidays.parse_definition_files_and_return_source(region, files)
      File.open("lib/#{Holidays::DEFINITIONS_PATH}/#{region.downcase.to_s}.rb","w") do |file|
        file.puts module_src
      end
      unless test_src.empty?
        File.open("#{TEST_DEFS_PATH}/test_defs_#{region.downcase.to_s}.rb","w") do |file|
          file.puts test_src
        end
      end
      puts "Done.\n\n"
    end
  end

  desc 'Build the definition manifest'
  task :manifest do
    File.open("lib/#{Holidays::DEFINITIONS_PATH}/MANIFEST","w") do |file|
      file.puts <<-EOH
==== Regional definitions
The following definition files are included in this installation:

  EOH
      FileList.new("lib/#{Holidays::DEFINITIONS_PATH}/*.rb").exclude(/version/).each do |str|
        file.puts('* ' + str.gsub(/^lib\/|\.rb$/, ''))
      end
    end
    puts "Updated manifest file."
  end
end

task :generate => ['generate:definitions', 'generate:manifest']
