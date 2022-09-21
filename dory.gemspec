# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'dory/version'

Gem::Specification.new do |s|
  s.name        = 'dory'
  s.version     = Dory.version
  s.date        = Dory.date
  s.summary     = 'Your development proxy for Docker'
  s.description = 'Dory lets you forget about IP addresses and ' \
    'port numbers while you are developing your application. ' \
    'Through the magic of local DNS and a reverse proxy, you ' \
    'can access your app at the domain of your choosing. For ' \
    'example, http://myapp.docker or http://this-is-a-really-long-name.but-its-cool-cause-i-like-it. ' \
    'Check it out on github at:  https://github.com/FreedomBen/dory'
  s.authors     = ['Ben Porter']
  s.email       = 'BenjaminPorter86@gmail.com'
  s.files       = ['lib/dory.rb'] + Dir['lib/dory/**/*']
  s.homepage    = 'https://github.com/FreedomBen/dory'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.1.0'

  s.executables << 'dory'

  s.add_runtime_dependency 'colorize', '~> 0.8'
  s.add_runtime_dependency 'thor', '~> 1.2'
  s.add_runtime_dependency 'ptools', '~> 1.4'
  s.add_runtime_dependency 'activesupport', '>= 5.2', '< 8.0'

  s.add_development_dependency 'rspec', '~> 3.11'
  s.add_development_dependency 'rake', '~> 13.0'
  s.add_development_dependency 'byebug', '~> 11.1'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 1.0'
  s.add_development_dependency 'rubocop', '~> 1.36'
end
