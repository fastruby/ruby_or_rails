release: rake db:migrate
web: bundle exec puma -C config/puma.rb
worker: bundle exec bin/jobs
bot: bundle exec rake discord:start_bot
