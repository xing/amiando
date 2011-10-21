# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "amiando/version"

Gem::Specification.new do |s|
  s.name        = "amiando"
  s.version     = Amiando::VERSION
  s.authors     = ["Albert Llop"]
  s.email       = ["mrsimo@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "amiando"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'yajl-ruby', '0.8.2'
  s.add_dependency 'typhoeus',  '0.2.4'

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'rake'
end
