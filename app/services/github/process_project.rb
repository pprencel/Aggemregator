# frozen_string_literal: true
require 'json'
module Github
  class ProcessProject < Github::GithubBase
    prepend ServiceModule::Base

    def call(project_id:)
      ActiveRecord::Base.transaction do
        project = Project.find(project_id)
        project.stars_count = fetch_stars_count(project.url)
        project.save

        gems_list = get_gems_list(project.url)
        gems_list.each do |gem_name|
          jewel = Jewel.find_or_initialize_by(name: gem_name)
          project.jewels << jewel unless jewel.id.in?(project.jewel_ids)
        end
      end
    end

    private

    def fetch_stars_count(base_url)
      repo_url = base_url.gsub(/github.com/, "#{user_auth}@api.github.com").gsub(/github.com/, 'github.com/repos')
      resp = github_resp_body(repo_url)
      json = JSON.parse(resp).deep_symbolize_keys!
      json.fetch(:stargazers_count)
    rescue StandardError => e
      raise Github::ProjectStarsError, "Failed to fetch stars count for #{repo_url} - #{e}"
    end

    def get_gems_list(base_url)
      default_gemfile_url = "#{base_url.gsub(/github.com/, "#{user_auth}@raw.githubusercontent.com")}/master/Gemfile"
      gemfile = begin
        github_resp_body(default_gemfile_url)
      rescue RestClient::NotFound # => e
        custom_gemfile_url = default_gemfile_url.gsub(/\/master\/Gemfile/, '/main/Gemfile')
        github_resp_body(custom_gemfile_url)
      end

      gemfile.scan(/gem ['"]([\w'-]+)['"],/).map(&:first)
    rescue StandardError => e
      raise Github::GemListError, "failed to fetch gems list - #{e}"
    end
  end
end
