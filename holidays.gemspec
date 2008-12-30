Gem::Specification.new do |s|
  s.name     = "holidays"
  s.version  = "0.9.4"
  s.date     = "2008-12-29"
  s.summary  = " A collection of Ruby methods to deal with statutory and other holidays.  You deserve a holiday!"
  s.email    = "code@dunae.ca"
  s.homepage = "http://code.dunae.ca/holidays"
  s.description = " A collection of Ruby methods to deal with statutory and other holidays.  You deserve a holiday!"
  s.has_rdoc = true
  s.authors  = ["Alex Dunae"]
  s.files    = Dir.glob("{data,lib,test}/**/*") + %w(README.rdoc LICENSE CHANGELOG REFERENCES rakefile.rb holidays.gemspec)
  s.test_files = Dir.glob("{test}/**/*")
  s.extra_rdoc_files = ['README.rdoc', 'data/SYNTAX', 'lib/holidays/MANIFEST', 'REFERENCES', 'CHANGELOG', 'LICENSE']
end
