require File.expand_path('../lib/jumpstarter_core/version', __FILE__)

Gem::Specification.new do |spec|
  spec.name          = "jump-starter"
  spec.version       = Jumpstarter::VERSION
  spec.authors       = ["Ehud Adler"]
  spec.email         = ["adlerehud@gmail.com"]

  spec.files         = `git ls-files`.split($\)
  spec.executables   = ["jumpstart"]

  spec.add_dependency 'commander'
  spec.add_dependency 'colorize'
  spec.add_dependency 'xcodeproj'
  spec.add_dependency 'terminal-table'


  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.summary       = %q{blah}
  spec.description   = %q{bla...etc}
  spec.homepage      = "http://www.ehudadler.com"
  spec.license       = "MIT"
end
