require "spec_helper"
require "puppetlabs-onceover/cli"
require "puppetlabs-onceover/codequality"
require "puppetlabs-onceover/codequality/docs"

RSpec.describe PuppetlabsOnceover::CodeQuality::Docs do
  # puppet strings will only give bad status if the executable is broken so no test

  it "Detects docs generate OK" do
    Dir.chdir "spec/testcase/good_docs" do
      expect(PuppetlabsOnceover::CodeQuality::Docs.puppet_strings(false)).to be true
    end
  end

  it "Works in HTML mode" do
    Dir.chdir "spec/testcase/good_docs" do
      expect(PuppetlabsOnceover::CodeQuality::Docs.puppet_strings(true)).to be true
    end
  end
end
