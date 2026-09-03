# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "puppetlabs-onceover/codequality/version"

Gem::Specification.new do |spec|
  spec.name          = "puppetlabs-onceover-codequality"
  spec.version       = PuppetlabsOnceover::CodeQuality::VERSION
  spec.authors       = ["Puppet, Inc."]
  spec.email         = ["modules-team@puppet.com"]
  spec.license       = "Apache-2.0"

  spec.summary       = %q{Lint and syntax validation for onceover}
  spec.homepage      = "https://github.com/puppetlabs/puppetlabs-onceover-codequality"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = Gem::Requirement.new('>= 3.2')

  spec.add_dependency 'openvox-strings', '>= 5.0', '< 8.0'
  spec.add_dependency 'puppetlabs-onceover', '~> 5.0'
  spec.add_dependency 'puppetlabs-syntax', '~> 7.0'
  spec.add_dependency 'puppet-lint', '~> 5.1'
  spec.add_dependency 'rake', '~> 13.3'
  spec.add_dependency 'rspec', '~> 3.13'
end
