require "spec_helper"
require "puppetlabs-onceover/cli"
require "puppetlabs-onceover/codequality"
require "puppetlabs-onceover/codequality/puppetfile"

RSpec.describe PuppetlabsOnceover::CodeQuality::Puppetfile do
  it "Detects bad Puppetfile" do
    Dir.chdir "spec/testcase/bad_puppetfile" do
      # capture logger output to check debug messages are output on failure
      capture_stringio = StringIO.new
      $logger = Logging.logger(capture_stringio)

      expect(PuppetlabsOnceover::CodeQuality::Puppetfile.puppetfile).to be false

      $logger = nil
      expect(capture_stringio.string).to match /Failed to evaluate/
    end
  end

  it "Detects good Puppetfile" do
    Dir.chdir "spec/testcase/good_puppetfile" do
      expect(PuppetlabsOnceover::CodeQuality::Puppetfile.puppetfile).to be true
    end
  end
end
