# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "evax/version"

Gem::Specification.new do |s|
  s.name        = "evax"
  s.version     = Evax::VERSION
  s.authors     = ["Fernando Guillen", "Juan Vidal"]
  s.email       = ["fguillen.mail@gmail.com", "juanjicho@gmail.com "]
  s.homepage    = ""
  s.summary     = "Very simple assets compressor"
  s.description = "Very simple assets compressor"

  s.rubyforge_project = "evax"
  
  s.add_development_dependency "bundler", ">= 1.0.0.rc.6"
  s.add_development_dependency "rake"
  s.add_development_dependency "uglifier"
  
  s.add_development_dependency "mocha"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
