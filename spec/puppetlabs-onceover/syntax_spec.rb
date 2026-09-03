require "spec_helper"
require "puppetlabs-onceover/cli"
require "puppetlabs-onceover/codequality"
require "puppetlabs-onceover/codequality/syntax"
require "logging"

RSpec.describe PuppetlabsOnceover::CodeQuality::Syntax do
  it "Detects syntax errors" do
    Dir.chdir "spec/testcase/bad_syntax" do
      # capture logger output to check debug messages are output on failure
      capture_stringio = StringIO.new
      $logger = Logging.logger(capture_stringio)
      expect(PuppetlabsOnceover::CodeQuality::Syntax.puppet).to be false

      $logger = nil
      expect(capture_stringio.string).to match /Syntax error/
    end
  end

  it "Detects syntax OK" do
    Dir.chdir "spec/testcase/good_syntax" do
      expect(PuppetlabsOnceover::CodeQuality::Syntax.puppet).to be true
    end
  end

  it "also runs the additional python YAML validation when python+pyyaml are available" do
    Dir.chdir "spec/testcase/good_syntax" do
      # This machine's `python` (as opposed to `python3`) may or may not have pyyaml
      # installed, so stub the availability check to force that branch and stub the
      # actual script invocation rather than depending on real python/pyyaml presence.
      allow(PuppetlabsOnceover::CodeQuality::Syntax).to receive(:system)
        .with("python --version && python -c 'import yaml'", err: File::NULL)
        .and_return(true)
      allow(PuppetlabsOnceover::CodeQuality::Executor).to receive(:run) do
        ["", true]
      end

      expect(PuppetlabsOnceover::CodeQuality::Syntax.puppet).to be true
    end
  end
end
