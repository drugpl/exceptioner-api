source "http://rubygems.org"

gemspec
gem "rack-test", :git => "git://github.com/krekoten/rack-test.git", :branch => "patch_method"

platforms :mri_18 do
  gem "ruby-debug"
  gem "SystemTimer"
end

platforms :mri_19 do
  gem "ruby-debug19", :require => "ruby-debug" if RUBY_VERSION < "1.9.3"
end
