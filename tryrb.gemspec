lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tryrb/version'

Gem::Specification.new do |s|
  s.name        = 'tryrb'
  s.version     = TryRb::Version
  s.licenses    = %w[MIT]
  s.summary     = %q{Try ruby code in a temporary file created.}
  s.description = s.summary
  s.authors     = ["Tony Han"]
  s.email       = 'h.bing612@gmail.com'
  s.files       = %w(LICENSE.md Rakefile tryrb.gemspec)
  s.files       += Dir.glob('lib/**/*.rb')
  s.files       += Dir.glob('spec/**/*')
  s.executables << 'tryrb'
  s.require_paths = ["lib"]
  s.homepage    = 'https://github.com/tony612/tryrb'
  s.add_dependency 'thor'
end
