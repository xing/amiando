# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "amiando/version"

Gem::Specification.new do |s|
  s.name        = "amiando"
  s.version     = Amiando::VERSION
  s.authors     = ["Jorge Dias", "Albert Llop"]
  s.email       = ["jorge@mrdias.com","mrsimo@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{A ruby client for the amiando REST API}
  s.description = %q{A ruby client for the amiando REST API with parallel requests in mind}

  s.rubyforge_project = "amiando"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency 'typhoeus'
  s.add_dependency 'multi_json'

  s.add_development_dependency 'minitest', '2.9.0'
  s.add_development_dependency 'webmock', '~> 1.7.6'
  s.add_development_dependency 'rake'
end
