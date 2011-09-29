# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "evalir/version"

Gem::Specification.new do |s|
  s.name        = "evalir"
  s.version     = Evalir::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Alexander Mossin"]
  s.email       = ["alexander@companybook.no"]
  s.homepage    = "http://github.com/companybook/Evalir"
  s.summary     = %q{Evalir is a library for evaluation of IR systems.}
  s.description = %q{Evalir offers a number of standard measurements, from the basic precision and recall to single value summaries such as NDCG and MAP.}

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "rake"

  # specify any dependencies here; for example:
  # s.add_runtime_dependency "rest-client"
  # s.add_runtime_dependency "rake/testtask"
end
