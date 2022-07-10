require 'rails_helper'

RSpec.describe Github::ProcessProject do

  let(:project_name) { "writings.io" }
  let(:project_url) { "https://github.com/chloerei/writings" }
  let(:project_desc) { "Source code of writings.io. " }
  let(:project) { Project.create(name: project_name, url: project_url, description: project_desc)}
  subject { described_class.call(project_id: project.id) }
  # Github::ProcessProject.call(project_id: project.id)

  before do
    stub_request(:get, "https://api.github.com/repos/chloerei/writings")
    .to_return(status: 200, body: file_fixture("writings/repo_data.json"))
  end

  it "should create Project and related Jewels" do

    stub_request(:get, "https://raw.githubusercontent.com/chloerei/writings/master/Gemfile")
    .to_return(status: 200, body: file_fixture("writings/Gemfile"))

    subject
    expect(Project.count).to eq(1)
    project = Project.first
    expect(project.name).to eq(project_name)
    expect(project.url).to eq(project_url)
    expect(project.description).to eq(project_desc)
    expect(project.stars_count).to eq(952)

    expect(Jewel.count).to eq(3)
    expect(Jewel.pluck(:name)).to match(["rails", "mongoid", "fakeweb"])
    jewel_ids = Jewel.pluck(:id)
    expect(project.jewel_ids).to match(jewel_ids)
  end

  it "should update project that already exists" do
    stub_request(:get, "https://raw.githubusercontent.com/chloerei/writings/master/Gemfile")
    .to_return(status: 200, body: file_fixture("writings/Gemfile"))

    jewel = Jewel.create(name: "rails")
    jewel.projects << project
    expect(Project.count).to eq(1)
    expect(Jewel.count).to eq(1)

    subject
    expect(Project.count).to eq(1)
    project = Project.first
    expect(project.url).to eq(project_url)
    expect(project.stars_count).to eq(952)
    expect(project.jewels.size).to eq(3)
  end

  it "should be able to fetch project gems if default project branch is main" do
    stub_request(:get, "https://raw.githubusercontent.com/chloerei/writings/master/Gemfile")
    .to_return(status: 404)

    stub_request(:get, "https://raw.githubusercontent.com/chloerei/writings/main/Gemfile")
    .to_return(status: 200, body: file_fixture("writings/Gemfile"))

    subject
    expect(Jewel.count).to eq(3)
    expect(Jewel.pluck(:name)).to match(["rails", "mongoid", "fakeweb"])
  end

  it "Should raise ProjectStarsError exception if failed to fetch gemlist" do
    stub_request(:get, "https://api.github.com/repos/chloerei/writings")
    .to_return(status: 404)

    expect { subject }.to raise_exception(Github::ProjectStarsError)
    expect(Project.count).to eq(1)
    expect(Jewel.count).to eq(0)
  end
end
