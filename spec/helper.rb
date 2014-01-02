require 'tryrb'
require 'rspec'

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def fixture_path
  File.expand_path('../fixtures', __FILE__)
end

def fixture_file_path(file_name)
  File.join fixture_path, file_name
end

def project_path
  File.expand_path('../..', __FILE__)
end
