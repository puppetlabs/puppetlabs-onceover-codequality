require "spec_helper"
require "onceover/cli"
require "onceover/codequality"
require "onceover/codequality/lint"

RSpec.describe Onceover::CodeQuality::Lint do
  it "Detects lint errors" do
    Dir.chdir "spec/testcase/bad_lint" do
      # capture logger output to check debug messages are output on failure
      capture_stringio = StringIO.new
      $logger = Logging.logger(capture_stringio)

      expect(Onceover::CodeQuality::Lint.puppet).to be false

      $logger = nil
      expect(capture_stringio.string).to match /WARNING:/
    end
  end

  it "Prints GitHub Actions annotations to stdout without logger prefix" do
    Dir.chdir "spec/testcase/bad_lint" do
      ENV['GITHUB_ACTION'] = 'true'

      capture_stringio = StringIO.new
      stdout_capture = StringIO.new

      $logger = Logging.logger(capture_stringio)
      allow($stdout).to receive(:puts) do |line|
        stdout_capture.puts(line)
      end

      expect(Onceover::CodeQuality::Lint.puppet).to be false

      ENV.delete('GITHUB_ACTION')
      $logger = nil

      # GitHub annotations (starting with ::) should go to stdout
      expect(stdout_capture.string).to match /^::(warning|error)/

      expect(capture_stringio.string).not_to match /^::(warning|error)/

      expect(capture_stringio.string).to match /FAILED/
    end
  end

  it "Detects lint OK" do
    Dir.chdir "spec/testcase/good_lint" do
      expect(Onceover::CodeQuality::Lint.puppet).to be true
    end
  end
end
