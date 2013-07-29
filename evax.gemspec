# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "evax/version"

Gem::Specification.new do |s|
  s.name        = "evax"
  s.version     = Evax::VERSION
  s.authors     = ["Fernando Guillen", "Juan Vidal"]
  s.email       = ["fguillen.mail@gmail.com", "juanjicho@gmail.com"]
  s.homepage    = "https://github.com/SponsorPay/Evax"
  s.summary     = "Very simple assets compressor"
  s.description = <<-EOS
    Evax is a simple asset packaging library for Ruby,
    providing JavaScript/CSS concatenation and compression
    using UglifyJS and a really simple regex based CSS
    compressor. Just because enough is enough.
  EOS

  s.rubyforge_project = "evax"

  s.add_development_dependency "bundler",   "1.3.5"
  s.add_development_dependency "rake",      "0.9.2.2"
  s.add_development_dependency "mocha",     "0.10.0"
  s.add_development_dependency "delorean",  "1.1.1"

  s.add_dependency "uglifier",  "1.2.3"
  s.add_dependency "watchr",    "0.7"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end