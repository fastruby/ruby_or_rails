release: rake db:migrate
web: bundle exec puma -C config/puma.rb
worker: bundle exec sidekiq -c 2 -q default
bot: bundle exec rake discord:start_bot
