source "https://rubygems.org"

git_source(:github) { |repo_name| "https://github.com/#{repo_name}" }

# Specify your gem's dependencies in onceover-helloworld.gemspec
gemspec

# Windows platform runtime deps. The published puppet/onceover rubygems.org
# artefacts are built on Linux and guard `ffi` / `win32ole` with build-host
# platform checks, so those deps never make it into the Linux-published
# artefact. Ruby 3.4+ removed win32ole from default gems, making the missing
# declaration fatal at require-time on Windows. Declaring them here in the
# Gemfile is evaluated on the install host at bundle time, so bundler pulls
# them on Windows only.
platforms :mingw, :x64_mingw, :mswin do
  gem 'ffi', '>= 1.15.5', '< 1.17.0', '!= 1.16.0', '!= 1.16.1', '!= 1.16.2'
  gem 'win32ole', '>= 1.8', '< 2.0'
end

group :release, optional: true do
  gem 'faraday-retry', require: false
  gem 'github_changelog_generator', require: false
end
