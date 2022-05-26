json.extract! project, :id, :name, :stars_count, :url, :created_at, :updated_at
json.url project_url(project, format: :json)
