# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "exceptioner_api/version"

Gem::Specification.new do |s|
  s.name        = "exceptioner-api"
  s.version     = Exceptioner::Api::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["TODO: Write your name"]
  s.email       = ["TODO: Write your email address"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "exceptioner-api"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "sinatra", "~> 1.3.1"
  s.add_dependency "sinatra-synchrony", "~> 0.1.0.beta.1"
  s.add_dependency "rabl", "~> 0.3.0"
  s.add_dependency "mongo", "~> 1.3"
  s.add_dependency "em-mongo", "~> 0.4.0"
  s.add_dependency "activemodel", "~> 3.0"
  s.add_dependency "tzinfo", "~> 0.3.22"

  s.add_development_dependency "rake"
  s.add_development_dependency "thin"
  s.add_development_dependency "turn", "0.8.2"
  s.add_development_dependency "tux"
  s.add_development_dependency "database_cleaner"
end
