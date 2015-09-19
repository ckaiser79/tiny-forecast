
# coding: utf-8
lib = File.expand_path('lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "tiny-forecast"
  spec.version       = '0.0-SNAPSHOT'
  spec.authors       = ["Christian Kaiser"]
  spec.email         = ["ckaiser@gmx.org"]
  spec.summary       = %q{A webpage, which displays a s curve chart, using google chart api.}
  spec.homepage      = "https://github.com/ckaiser79/tiny-forecast"
  spec.license       = "MIT"

  spec.files         = ['lib/sigma.rb']
  spec.executables   = ['webapp/webapp.rb']
  spec.test_files    = ['spec/sigma/*_spec.rb']
  spec.require_paths = ["lib"]
end
