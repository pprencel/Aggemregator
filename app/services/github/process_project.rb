# frozen_string_literal: true
require 'json'

class Github::ProcessProject < Github::GithubBase
  prepend ServiceModule::Base

  def call(project_name:, project_url:)
    project = Project.find_or_initialize_by(name: project_name)
    # next if project.persisted?
    stars_count = fetch_stars_count(project_url)
    project.update(stars_count: stars_count, url: project_url)

    gems_list = get_gems_list(project_url)
    gems_list.each do |gem_name|
      jewel = Jewel.find_or_initialize_by(name: gem_name)
      project.jewels << jewel
    rescue ActiveRecord::RecordNotUnique
      Rails.logger.debug "project has already assigned gem #{gem_name}"
      next
    end
  end

  private

  def fetch_stars_count(base_url)
    repo_url = base_url.gsub(/github.com/, "#{user_auth}@api.github.com").gsub(/github.com/, 'github.com/repos')
    resp = github_resp_body(repo_url)
    json = JSON.parse(resp)
    json['stargazers_count']
  rescue => e
    Rails.logger.debug "Failed to fetch stars count for #{repo_url} - #{e}"
    0
  end

  def get_gems_list(base_url)
    default_gemfile_url = "#{base_url.gsub(/github.com/, "#{user_auth}@raw.githubusercontent.com")}/master/Gemfile"
    gemfile = begin
      github_resp_body(default_gemfile_url)
    rescue RestClient::NotFound # => e
      custom_gemfile_url = default_gemfile_url.gsub(/\/master\/Gemfile/, '/main/Gemfile')
      github_resp_body(custom_gemfile_url)
    rescue
      Rails.logger.debug "failed to fetch #{default_gemfile_url}"
      ''
    end

    gemfile.scan(/gem ['"]([\w'-]+)['"],/).map(&:first)
  rescue => e
    Rails.logger.debug "failed to fetch gems list #{e}"
    []
  end
end
