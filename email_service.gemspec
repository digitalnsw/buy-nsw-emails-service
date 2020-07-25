$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "email_service/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "email_service"
  spec.version     = EmailService::VERSION
  spec.authors     = ["Arman"]
  spec.email       = ["arman.zrb@gmail.com"]
  spec.homepage    = ""
  spec.summary     = "Summary of EmailService."
  spec.description = "Description of EmailService."
  spec.license     = "MIT"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
end
