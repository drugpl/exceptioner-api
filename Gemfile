source "http://rubygems.org"

gemspec
gem "rack-test", :git => "git://github.com/krekoten/rack-test.git", :branch => "patch_method"
gem "grape", :git => "git://github.com/LTe/grape.git", :branch => "patch-method"
gem "grape-rabl"

platforms :mri_18 do
  gem "ruby-debug"
  gem "SystemTimer"
end

platforms :mri_19 do
  gem "ruby-debug19", :require => "ruby-debug" if RUBY_VERSION < "1.9.3"
end

gem 'mongoid'
gem 'bson_ext'
