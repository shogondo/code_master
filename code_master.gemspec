# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'code_master/version'

Gem::Specification.new do |gem|
  gem.name          = "code_master"
  gem.version       = CodeMaster::VERSION
  gem.authors       = ["Shou Takenaka"]
  gem.email         = ["shou_takenaka@guihua.jp"]
  gem.description   = %q{code_master adds code value check helper method to Class}
  gem.summary       = %q{Code Masterizer}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "json", "~> 1.7.7"
end
