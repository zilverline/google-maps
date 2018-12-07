# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "google-maps/version"

Gem::Specification.new do |s|
  s.name        = "google-maps"
  s.version     = Google::Maps::VERSION
  s.authors     = ["Daniel van Hoesel"]
  s.email       = ["daniel@danielvanhoesel.nl"]
  s.homepage    = "http://zilverline.com/"
  s.summary     = %q{Ruby wrapper for the Google Maps API}
  s.description = %q{This is a ruby wrapper for the Google Maps api}

  s.rubyforge_project = "google-maps"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency('bundler', '~> 1.0')
  s.add_development_dependency('rake', '~> 12.3.2')
  s.add_development_dependency('rspec', '~> 3.8.0')
  s.add_development_dependency('rspec-its', '~> 1.2')
  s.add_development_dependency('rspec-collection_matchers', '~> 1.1')
  s.add_development_dependency('mocha', '~> 1.7.0')
  s.add_development_dependency('simplecov', '~> 0.5')
  s.add_development_dependency('coveralls', '~> 0.8')
  s.add_development_dependency('yard', '>= 0.9.11')
  s.add_dependency('json', '>= 1.7.5')
  s.add_dependency('hashie', '>= 2.0.5')
  s.add_dependency('httpclient', '>= 2.7.1')
  s.add_dependency('ruby-hmac', '~> 0.4.0')
end
