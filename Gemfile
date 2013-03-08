source "http://rubygems.org"

# Specify your gem's dependencies in amiando.gemspec
gemspec

unless ENV["TRAVIS"]
  gem 'debugger',   :platforms => :ruby_19
  gem 'ruby-debug', :platforms => :mri_18
end

group :development do
  gem 'minitest-reporters', '= 0.8.0'
  gem 'guard-minitest'
  gem 'typhoeus', '0.4.2'
  if RbConfig::CONFIG['target_os'] =~ /darwin/i
    gem 'rb-fsevent', '>= 0.4.0', :require => false
    gem 'growl',      '~> 1.0.3', :require => false
  end
end
