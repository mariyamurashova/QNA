# lib/tasks/sidekiq.rake
namespace :sidekiq do
  task :start do
    sh "bundle exec sidekiq -C config/sidekiq.yml -e production -d"
  end

  task :stop do
    sh "bundle exec sidekiqctl stop production"
  end

  task :restart do
    sh "bundle exec sidekiqctl restart production"
  end
end
