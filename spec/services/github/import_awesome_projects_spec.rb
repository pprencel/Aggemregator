require 'rails_helper'

RSpec.describe Github::ImportAwesomeProjects do
  let(:response) { "- [writings.io](https://github.com/chloerei/writings) - Source code of writings.io. 🔥 🚀" }

  subject { described_class.call }

  it "should parse README file and call ProcessProject service" do
    stub_request(:get, "https://raw.githubusercontent.com/asyraffff/Open-Source-Ruby-and-Rails-Apps/master/README.md")
    .to_return(status: 200, body: response, headers: {})

    expect_any_instance_of(Github::ProcessProject).to receive(:call).with(project_id: anything).once.and_return(true)
    subject

    expect(Project.count).to eq(1)
    project = Project.first
    expect(project.name).to eq("writings.io")
    expect(project.url).to eq("https://github.com/chloerei/writings")
    expect(project.description).to eq("Source code of writings.io. ")
  end

  context "when project url is github organization" do
    let(:response) { "- [Ruby-Starter-Kits](https://github.com/Ruby-Starter-Kits/) - Starter kits to help you get up and running with Ruby quickly. 🔥 🚀" }

    it "Should not create project" do
      stub_request(:get, "https://raw.githubusercontent.com/asyraffff/Open-Source-Ruby-and-Rails-Apps/master/README.md")
      .to_return(status: 200, body: response, headers: {})

      expect_any_instance_of(Github::ProcessProject).not_to receive(:call)
      subject
      expect(Project.count).to eq(0)
    end
  end
end
