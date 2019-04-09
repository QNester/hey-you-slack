
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "hey_you_slack/version"

Gem::Specification.new do |spec|
  spec.name          = "hey-you-slack"
  spec.version       = HeyYouSlack::VERSION
  spec.authors       = ["Sergey Nesterov"]
  spec.email         = ["qnesterr@gmail.com"]

  spec.summary       = "Hello"
  spec.description   = "Hello"
  spec.homepage      = "https://github.com/QNester/hey-you-slack"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = "https://github.com/QNester/hey-you-slack"
    spec.metadata["changelog_uri"] = "https://github.com/QNester/hey-you-slack/CHANGELOG.md"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "hey-you", '~> 0.1'
  spec.add_runtime_dependency "httparty", '~> 0.16'

  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", '~> 3.4'
  spec.add_development_dependency "ffaker", '~> 2.9'
end
