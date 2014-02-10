# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fitkit/version'

Gem::Specification.new do |spec|
  spec.add_development_dependency 'bundler', '~> 1.0'
  spec.add_dependency "oauth"
  spec.authors = ["Kieran Anddrews"]
  spec.description = %q{Simple wrapper for the Fitbit API}
  spec.email = ['hiddentiger@gmail.com']
  spec.files = %w(README.md fitkit.gemspec)
  spec.files += Dir.glob("lib/**/*.rb")
  spec.homepage = 'https://github.com/TigerWolf/fitkit'
  spec.licenses = ['MIT']
  spec.name = 'fitkit'
  spec.require_paths = ['lib']
  spec.required_rubygems_version = '>= 1.3.5'
  spec.summary = "Ruby toolkit for working with the Fitbit API"
  spec.version = Fitkit::VERSION.dup
end
