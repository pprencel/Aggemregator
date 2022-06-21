require 'rails_helper'

RSpec.describe Github::ProcessProject do

  let(:project_name) { "writings.io" }
  let(:project_url) { "https://github.com/chloerei/writings" }

  subject { described_class.call(project_name: project_name, project_url: project_url) }
  # Github::ProcessProject.call(project_name: "writings.io", project_url: "https://github.com/chloerei/writings")

  it "should create Project and related Jewels" do
    stub_request(:get, "https://api.github.com/repos/chloerei/writings")
    .to_return(status: 200, body: file_fixture("writings/repo_data.json"))

    stub_request(:get, "https://raw.githubusercontent.com/chloerei/writings/master/Gemfile")
    .to_return(status: 200, body: file_fixture("writings/Gemfile"))

    subject
    expect(Project.count).to eq(1)
    project = Project.first
    expect(project.name).to eq(project_name)
    expect(project.url).to eq(project_url)
    expect(project.stars_count).to eq(952)

    expect(Jewel.count).to eq(3)
    expect(Jewel.pluck(:name)).to match(["rails", "mongoid", "fakeweb"])
    jewel_ids = Jewel.pluck(:id)
    expect(project.jewel_ids).to match(jewel_ids)
  end
end
