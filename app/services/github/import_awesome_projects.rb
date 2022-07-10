# frozen_string_literal: true
require 'rest-client'
require 'json'

class Github::ImportAwesomeProjects < Github::GithubBase
  prepend ServiceModule::Base

  NAME_REGEXP = /\[([\S]+)\]/
  URL_REGEXP = /\(([\S]+)\)/
  DESC_REGEXP = /([\s\w.,]+)/

  def call
    file_body = awesome_repo_readme_file
    regexp = /- #{NAME_REGEXP}#{URL_REGEXP} - #{DESC_REGEXP}/
    projects_data_map = file_body.scan(regexp)
    projects_data_map.each do |project_name, project_url, project_desc|
      begin
        Github::ProcessProject.call(project_name: project_name, project_url: project_url, project_desc: project_desc)
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