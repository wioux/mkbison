lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'bison/version'

Gem::Specification.new do |spec|
  spec.name          = "mkbison"
  spec.version       = Bison::VERSION
  spec.authors       = ["Peter Woo"]
  spec.email         = ["peter@wioux.net"]
  spec.summary       = %q{Tool to generate bison parser C extensions}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.extensions = %w[ext/bison_parser/extconf.rb]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rake-compiler"
  spec.add_runtime_dependency "cocaine"
end
