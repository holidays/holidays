require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'
require 'rake/gempackagetask'
require 'fileutils'
require 'lib/holidays'
require 'bin/build_defs'

def_list = {
            :au => ['data/au.yaml', 'data/common_methods.yaml'],
            :ca => ['data/ca.yaml', 'data/common_methods.yaml', 'data/north_america_informal.yaml'],
            :dk => ['data/dk.yaml', 'data/common_methods.yaml'],
            :de => ['data/de.yaml', 'data/common_methods.yaml'],
            :es => ['data/es.yaml', 'data/common_methods.yaml'],
            :fr => ['data/fr.yaml', 'data/common_methods.yaml'],
            :gb => ['data/gb.yaml', 'data/common_methods.yaml'],
            :ie => ['data/ie.yaml', 'data/common_methods.yaml'],
            :is => ['data/is.yaml', 'data/common_methods.yaml'],
            :it => ['data/it.yaml', 'data/common_methods.yaml'],
            :lv => ['data/lv.yaml', 'data/common_methods.yaml'],
            :mx => ['data/mx.yaml', 'data/common_methods.yaml', 'data/north_america_informal.yaml'],
            :nl => ['data/nl.yaml', 'data/common_methods.yaml'],
            :us => ['data/us.yaml', 'data/common_methods.yaml', 'data/north_america_informal.yaml'],
            :united_nations => ['data/united_nations.yaml'],
            :za => ['data/za.yaml', 'data/common_methods.yaml']
           }

def_list[:north_america] = def_list[:ca] | def_list[:mx] | def_list[:us]

def_list[:europe] = def_list[:dk] | def_list[:de] | def_list[:es] | def_list[:fr] | def_list[:gb] | def_list[:ie] | def_list[:is] | def_list[:it] |def_list[:nl] |def_list[:lv]


desc 'Run the unit tests.'
Rake::TestTask.new do |t|
  t.libs << 'lib'
  t.libs << 'lib/test'
  t.test_files = FileList['test/test*.rb'].exclude('test_helper.rb')
  t.verbose = false
end

namespace 'definitions' do
  task :build_all do
    def_list.each do |region, files|
      puts "Building #{region.to_s.upcase} definition module:"
      files.uniq!
      parsed = parse_holiday_defs(region.to_s.upcase, files)
      File.open("lib/holidays/#{region.to_s}.rb","w") do |file|
        file.puts parsed
      end
      puts "Done.\n\n"
    end
  end
end


task :manifest do
  File.open("MANIFEST","w") do |file|
    file.puts <<-EOH
==== Regional definitions
The following definition files are included in the default
installation:

EOH

#  def_list.each do |region, includes|
#    file.puts('* holidays/' + region.to_s)
#    includes.each do |inc|
#      file.puts('  * holidays/' + inc.gsub(/^data\/|\.yaml$/, ''))
#    end
#  end

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
  rdoc.rdoc_files.include('README')
  rdoc.rdoc_files.include('MANIFEST')
  rdoc.rdoc_files.include('CUSTOM DATES')
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
  s.files = FileList["{lib}/**/*"].to_a
  s.test_files = Dir.glob('test/test_*.rb') 
  s.has_rdoc = true
  s.extra_rdoc_files = ['README', 'CUSTOM DATES', 'REFERENCES', 'LICENSE']
  s.rdoc_options << '--all' << '--inline-source' << '--line-numbers'
end

desc 'Build the gem.'
Rake::GemPackageTask.new(spec) do |pkg| 
  pkg.need_zip = true
  pkg.need_tar = true 
end 