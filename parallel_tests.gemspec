$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
name = "parallel_tests"
require "#{name}/version"

Gem::Specification.new name, ParallelTests::VERSION do |s|
  s.summary = "Run Test::Unit / RSpec / Cucumber in parallel"
  s.authors = ["Michael Grosser"]
  s.email = "michael@grosser.it"
  s.homepage = "http://github.com/grosser/#{name}"
  s.files = `git ls-files`.split("\n")
  s.license = "MIT"
  s.executables = ["parallel_cucumber", "parallel_rspec", "parallel_test"]
  s.add_runtime_dependency "parallel"
  s.add_dependency "win32-dir"
  s.add_dependency 'rspec', '>=2.4'
  s.add_dependency "cucumber"
  s.add_dependency "rake"
end
