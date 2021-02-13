# -*- encoding: utf-8 -*-
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "brite_verify/version"

Gem::Specification.new do |gem|
  gem.name          = "brite_verify"
  gem.version       = BriteVerify::VERSION
  gem.licenses      = ["MIT"]
  gem.authors       = ["Simon Schoeters"]
  gem.email         = ["https://github.com/cimm/brite_verify/issues"]
  gem.description   = %q{Ruby interface for BriteVerify’s paying e-mail verification service.}
  gem.summary       = %q{BriteVerify is a paying e-mail verification service. You pass it an e-mail address and it tells you if the e-mail address is real or not. They offer a typical REST-like API. This gem wraps the API in a more Ruby friendly syntax.}
  gem.homepage      = "https://github.com/cimm/brite_verify"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "minitest", "~> 5.14"
  gem.add_development_dependency "rake",     "~> 13.0"
  gem.add_development_dependency "webmock",  "~> 3.11"
end
