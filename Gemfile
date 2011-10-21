source "http://rubygems.org"

# Specify your gem's dependencies in amiando.gemspec
gemspec

unless ENV["TRAVIS"]
  gem 'ruby-debug19', :platforms => :ruby_19
  gem 'ruby-debug', :platforms => :mri_18
end

group :development do
  gem 'guard-minitest'
  if RbConfig::CONFIG['target_os'] =~ /darwin/i
    gem 'rb-fsevent', '>= 0.4.0', :require => false
    gem 'growl',      '~> 1.0.3', :require => false
  end
end
