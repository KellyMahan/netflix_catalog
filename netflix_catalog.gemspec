lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

Gem::Specification.new do |s|
  s.name = 'netflix_catalog'
  s.version = "0.0.1"
  s.platform = Gem::Platform::RUBY
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Kelly Mahan"]
  s.autorequire = 'netflix_catalog'
  s.date = '2012-08-30'
  s.summary     = "Gem that interfaces with netflix's catalog api."
  s.description = "Gem that interfaces with netflix's catalog api."
  s.email = 'kmahan@kmahan.com'
  
  s.files = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  
  s.require_path = 'lib'
  s.add_dependency "oauth"
  s.add_dependency "nokogiri"

end
