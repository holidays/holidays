source 'https://rubygems.org'

gemspec

group :development do
  # MRI only: rdoc pulls in rbs, whose native extension cannot build on JRuby.
  # Both gems exist to silence warnings and are not needed to run the suite.
  gem 'irb', platform: :mri
  gem 'rdoc', platform: :mri
end
