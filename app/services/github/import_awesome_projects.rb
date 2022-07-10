# frozen_string_literal: true
require 'rest-client'
require 'json'

class Github::ImportAwesomeProjects < Github::GithubBase
  prepend ServiceModule::Base

  def call
    file_body = awesome_repo_readme_file
    project_url_map = file_body.scan(/- \[([\S]+)\]\(([\S]+)\)/)
    project_url_map.each do |project_name, project_url|
      begin
        Github::ProcessProject.call(project_name: project_name, project_url: project_url)
      rescue StandardError => e
        notify_about_error("Failed to ProcessProject: #{project_name}")
        Rails.logger.debug e.message
      end
    end
  end

  private

  def awesome_repo_readme_file
    repo_url = "https://#{user_auth}@raw.githubusercontent.com/asyraffff/Open-Source-Ruby-and-Rails-Apps/master/README.md"
    github_resp_body(repo_url)
  end
end
