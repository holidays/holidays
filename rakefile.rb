require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'fileutils'
require 'lib/holidays'
require 'data/build_defs'

def_list = {
            :au => ['data/au.yaml'],
            :ca => ['data/ca.yaml', 'data/north_america_informal.yaml'],
            :dk => ['data/dk.yaml'],
            :de => ['data/de.yaml'],
            :es => ['data/es.yaml'],
            :fr => ['data/fr.yaml'],
            :gb => ['data/gb.yaml'],
            :ie => ['data/ie.yaml'],
            :is => ['data/is.yaml'],
            :it => ['data/it.yaml'],
            :mx => ['data/mx.yaml', 'data/north_america_informal.yaml'],
            :nl => ['data/nl.yaml'],
            :pt => ['data/pt.yaml'],
            :se => ['data/se.yaml'],
            :us => ['data/us.yaml', 'data/north_america_informal.yaml'],
            :united_nations => ['data/united_nations.yaml'],
            :za => ['data/za.yaml']
           }

def_list[:north_america] = []
[:ca, :mx, :us].each do |r|
  def_list[:north_america] += def_list[r]
end
def_list[:north_america].uniq!

def_list[:scandinavia] = []
[:dk, :is, :se].each do |r|
  def_list[:scandinavia] += def_list[r]
end
def_list[:scandinavia].uniq!

def_list[:europe] = []
[:dk, :de, :es, :fr, :gb, :ie, :is, :it, :nl, :pt, :se].each do |r|
  def_list[:europe] += def_list[r]
end
def_list[:europe].uniq!


desc 'Run the unit tests.'
Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.libs << 'lib/test'
  t.test_files = FileList['test/test*.rb'].exclude('test_helper.rb')
  t.verbose = false
end

namespace 'definitions' do
  desc 'Build holiday definition files'
  task :build_all do
    def_list.each do |region, files|
      puts "Building #{region.to_s.upcase} definition module:"
      files.uniq!
      module_src, test_src = parse_holiday_defs(region.to_s.upcase, files)
      File.open("lib/holidays/#{region.to_s}.rb","w") do |file|
        file.puts module_src
      end
      unless test_src.empty?
        File.open("test/test_defs_#{region.to_s}.rb","w") do |file|
          file.puts test_src
        end
      end
      puts "Done.\n\n"
    end
  end
end


task :doc => [:manifest, :rdoc]

desc 'Build the definition manifest.'
task :manifest do
  File.open("lib/holidays/MANIFEST","w") do |file|
    file.puts <<-EOH
==== Regional definitions
The following definition files are included in the default
installation:

EOH
    FileList.new('lib/holidays/*.rb').each do |str|
      file.puts('* ' + str.gsub(/^lib\/|\.rb$/, ''))
    end
  end
end

desc 'Generate documentation.'
Rake::RDocTask.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'doc'
  rdoc.title    = 'Ruby Holidays Gem'
  rdoc.options << '--all' << '--inline-source' << '--line-numbers'
  rdoc.options << '--charset' << 'utf-8'
  rdoc.template = 'extras/rdoc_template.rb'
  #rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('data/SYNTAX')
  rdoc.rdoc_files.include('lib/holidays/MANIFEST')
  rdoc.rdoc_files.include('REFERENCES')
  rdoc.rdoc_files.include('LICENSE')
  rdoc.rdoc_files.include('lib/*.rb')
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
  s.files = FileList["{lib}/**/*", "{data}/**/*", "bin/*"].to_a
  s.bindir = 'bin'
  s.executables = ["build_holiday_defs"]
  s.default_executable = %q{build_holiday_defs}
  s.test_files = Dir.glob('test/test_*.rb') 
  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'lib/holidays/MANIFEST', 'CUSTOM DATES', 'REFERENCES', 'LICENSE']
  s.rdoc_options << '--all' << '--inline-source' << '--line-numbers' << '--charset' << 'utf-8'
end

desc 'Build the gem.'
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_zip = true
  pkg.need_tar = true 
end 