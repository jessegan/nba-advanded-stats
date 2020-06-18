require_relative 'lib/nba_advanced_stats/version'

Gem::Specification.new do |spec|
  spec.name          = "nba_advanced_stats"
  spec.version       = NbaAdvancedStats::VERSION
  spec.authors       = ["jessegan"]
  spec.email         = ["jesse13579@gmail.com"]

  spec.summary       = "Find out advanced statistics about NBA teams and their performance during any NBA season from 1980 to 2019."
  #spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/jessegan/nba-advanded-stats"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  #spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/jessegan/nba-advanded-stats"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
