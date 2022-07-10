require 'rails_helper'

RSpec.describe Github::ImportAwesomeProjects do

  let(:project_name) { "writings.io" }
  let(:project_url) { "https://github.com/chloerei/writings" }
  let(:project_desc) { "Source code of writings.io. " }

  subject { described_class.call }

  it "should parse README file and call ProcessProject service" do
    stub_request(:get, "https://raw.githubusercontent.com/asyraffff/Open-Source-Ruby-and-Rails-Apps/master/README.md")
    .to_return(status: 200, body: file_fixture("awesome_README.md").read, headers: {})

    expect_any_instance_of(Github::ProcessProject).to receive(:call).with(project_id: anything).once.and_return(true)
    subject

    expect(Project.count).to eq(1)
    project = Project.first
    expect(project.name).to eq(project_name)
    expect(project.url).to eq(project_url)
    expect(project.description).to eq(project_desc)
  end
end
