$: << File.expand_path(File.dirname(__FILE__))

require "lib/throttle/version"

Gem::Specification.new do |s|
  s.name = "throttle"
  s.version = "#{Throttle::VERSION}"
  s.author = "Rafael Fernández López"
  s.email = "ereslibre@ereslibre.es"
  s.summary = "A distributed bug tracking system"
  s.homepage = "http://www.ereslibre.es/"
  s.description = "A distributed bug tracking system"
  s.files = Dir.glob("{bin,lib}/**/*")
  s.executables = ["th"]
  s.require_path = "lib"
end
