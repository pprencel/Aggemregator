desc 'Trigger import awesome projects'
task :trigger_import_awesome => :environment do
  pp "=== Start ==="
  Github::ImportAwesomeProjects.call
  # Github::ProcessProject.call(project_name: "writings.io", project_url: "https://github.com/chloerei/writings")
  pp "=== Stop ==="
end