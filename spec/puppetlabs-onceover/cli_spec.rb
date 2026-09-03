require "spec_helper"
require "puppetlabs-onceover/cli"
require "puppetlabs-onceover/codequality"
require "puppetlabs-onceover/codequality/cli"

RSpec.describe PuppetlabsOnceover::CodeQuality::CLI do
  let(:exit_calls) { [] }

  before(:each) do
    # `exit` inside the `run` block is called with an implicit receiver, which
    # resolves to the private Kernel#exit instance method mixed into whatever
    # object Cri evaluates the block against -- NOT the `Kernel.exit` module
    # function, so stubbing `Kernel.exit` alone would not intercept it and would
    # abort the rspec process. Stub the instance method everywhere instead and
    # record calls in `exit_calls` since we can't spy on `Kernel` itself here.
    calls = exit_calls
    allow_any_instance_of(Object).to receive(:exit) { |_receiver, code = 0| calls << code }
  end

  def run_command(argv)
    # hard_exit: false so a Cri parse error (or our own stubbed `exit`) doesn't
    # actually terminate the rspec process.
    PuppetlabsOnceover::CodeQuality::CLI.command.run(argv, {}, hard_exit: false)
  end

  it "runs all four checks by default and reports success when everything passes" do
    allow(PuppetlabsOnceover::CodeQuality::Puppetfile).to receive(:puppetfile).and_return(true)
    allow(PuppetlabsOnceover::CodeQuality::Syntax).to receive(:puppet).and_return(true)
    allow(PuppetlabsOnceover::CodeQuality::Lint).to receive(:puppet).and_return(true)
    allow(PuppetlabsOnceover::CodeQuality::Docs).to receive(:puppet_strings).and_return(true)

    run_command([])

    expect(PuppetlabsOnceover::CodeQuality::Puppetfile).to have_received(:puppetfile)
    expect(PuppetlabsOnceover::CodeQuality::Syntax).to have_received(:puppet)
    expect(PuppetlabsOnceover::CodeQuality::Lint).to have_received(:puppet)
    expect(PuppetlabsOnceover::CodeQuality::Docs).to have_received(:puppet_strings).with(false)
    expect(exit_calls).to be_empty
  end

  it "skips puppetfile/syntax/lint/docs checks when the corresponding --no-* flag is given" do
    allow(PuppetlabsOnceover::CodeQuality::Puppetfile).to receive(:puppetfile)
    allow(PuppetlabsOnceover::CodeQuality::Syntax).to receive(:puppet)
    allow(PuppetlabsOnceover::CodeQuality::Lint).to receive(:puppet)
    allow(PuppetlabsOnceover::CodeQuality::Docs).to receive(:puppet_strings)

    run_command(['--no_puppetfile', '--no_syntax', '--no_lint', '--no_docs'])

    expect(PuppetlabsOnceover::CodeQuality::Puppetfile).not_to have_received(:puppetfile)
    expect(PuppetlabsOnceover::CodeQuality::Syntax).not_to have_received(:puppet)
    expect(PuppetlabsOnceover::CodeQuality::Lint).not_to have_received(:puppet)
    expect(PuppetlabsOnceover::CodeQuality::Docs).not_to have_received(:puppet_strings)
  end

  it "passes html_docs through to the Docs check when --html-docs is given" do
    allow(PuppetlabsOnceover::CodeQuality::Puppetfile).to receive(:puppetfile).and_return(true)
    allow(PuppetlabsOnceover::CodeQuality::Syntax).to receive(:puppet).and_return(true)
    allow(PuppetlabsOnceover::CodeQuality::Lint).to receive(:puppet).and_return(true)
    allow(PuppetlabsOnceover::CodeQuality::Docs).to receive(:puppet_strings).and_return(true)

    run_command(['--html_docs'])

    expect(PuppetlabsOnceover::CodeQuality::Docs).to have_received(:puppet_strings).with(true)
  end

  it "exits 1 and logs a failure message when any check fails" do
    allow(PuppetlabsOnceover::CodeQuality::Puppetfile).to receive(:puppetfile).and_return(true)
    allow(PuppetlabsOnceover::CodeQuality::Syntax).to receive(:puppet).and_return(false)
    allow(PuppetlabsOnceover::CodeQuality::Lint).to receive(:puppet).and_return(true)
    allow(PuppetlabsOnceover::CodeQuality::Docs).to receive(:puppet_strings).and_return(true)

    run_command([])

    expect(exit_calls).to eq([1])
  end
end
