# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "exceptioner_api/version"

Gem::Specification.new do |s|
  s.name        = "exceptioner-api"
  s.version     = Exceptioner::API::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Paweł Pacana"]
  s.email       = ["pawel.pacana@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Collects errors from your app.}
  s.description = %q{Exceptioner API is a service to collect error notifications as well as other types of events in your application.}

  s.rubyforge_project = "exceptioner-api"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "goliath", "~> 0.9.4"
  s.add_development_dependency "em-spec", "~> 0.2.5"
  s.add_development_dependency "em-http-request", "~> 1.0.0"
  s.add_development_dependency "rake", "~> 0.9.2"
end
