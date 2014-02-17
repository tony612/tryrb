source 'https://rubygems.org'

group :development do
  gem 'pry'
  gem 'pry-debugger'
  gem 'pry-rescue'
  gem 'guard-rspec'
end

group :test do
  gem 'rspec'
  gem 'fakefs'
  gem 'simplecov', :require => false
  gem 'coveralls', :require => false
end

platforms :rbx do
  gem 'racc'
  gem 'rubinius-coverage', '~> 2.0'
  gem 'rubysl', '~> 2.0'
end

gemspec
