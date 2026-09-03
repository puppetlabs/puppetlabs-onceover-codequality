require "puppetlabs-onceover/codequality/lint"
require "puppetlabs-onceover/codequality/syntax"
require "puppetlabs-onceover/codequality/docs"
require "puppetlabs-onceover/codequality/puppetfile"
require "puppetlabs-onceover/codequality/environment"
require "puppetlabs-onceover/codequality/executor"
require "puppetlabs-onceover/codequality/formatter"
class PuppetlabsOnceover
  module CodeQuality
    class CLI
      def self.command
        @cmd ||= Cri::Command.define do
          name 'codequality'
          usage 'codequality [--no-syntax] [--no-lint] [--no-docs] [--html-docs] [--no-puppetfile]'
          summary "Code Quality checking for onceover"
          description <<-DESCRIPTION
              Check files in your Control Repository for Lint and Syntax errors
          DESCRIPTION

          flag nil, :no_lint, 'Do not check for lint errors', :argument => :optional
          flag nil, :no_puppetfile, 'Do not check Puppetfile for syntax errors', :argument => :optional
          flag nil, :no_syntax, 'Do not check for syntax errors', :argument => :optional
          flag nil, :no_docs, 'Do not generate documentation (puppet-strings) for local modules', :argument => :optional
          flag nil, :html_docs, 'Generate docs in HTML format instead of markdown', :argument => :optional

          run do |opts, args, cmd|
            no_lint = opts[:no_lint] || false
            no_syntax = opts[:no_syntax] || false
            no_docs = opts[:no_docs] || false
            no_puppetfile = opts[:no_puppetfile] || false
            html_docs = opts[:html_docs] || false
            status = true

            logger.info "Running Code Quality tests"

            if !no_puppetfile
              status &= PuppetlabsOnceover::CodeQuality::Puppetfile.puppetfile
            end

            if !no_syntax
              status &= PuppetlabsOnceover::CodeQuality::Syntax.puppet
            end

            if !no_lint
              status &= PuppetlabsOnceover::CodeQuality::Lint.puppet
            end

            if !no_docs
              status &= PuppetlabsOnceover::CodeQuality::Docs.puppet_strings(html_docs)
            end

            if status
              logger.info "Code Quality tests PASSED, have a nice day"
            else
              logger.error "Code Quality tests FAILED, see previous error(s)"
              exit 1
            end
          end
        end
      end
    end
  end
end

PuppetlabsOnceover::CLI::Run.command.add_command(PuppetlabsOnceover::CodeQuality::CLI.command)
