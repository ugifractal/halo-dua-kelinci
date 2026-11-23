namespace :assets do
  desc "Build JavaScript and CSS with yarn"
  task :build do
    [ "yarn install --frozen-lockfile", "yarn build", "yarn build:css" ].each do |command|
      abort "Gagal menjalankan: #{command}" unless system(command)
    end
  end
end

if Rake::Task.task_defined?("assets:precompile")
  Rake::Task["assets:precompile"].enhance([ "assets:build" ])
end
