# README

Welcome to the Ruby or Rails Discord Bot!

# Project Summary

Get Daily Puzzles delivered to your preferred server channel with a "Is it Ruby or Rails?" style question.

# Requirements
- PostgreSQL
- Redis
- Ruby 3.4.2

# Set Up
```
  git clone git@github.com:ombulabs/ruby-or-rails.git
  cd ruby-or-rails
  ./bin/setup
```
Check the .env.sample file for information on what environment variables you will need.

# Run the Discord bot

Registering and re-registering the bot commands:
`bundle exec rake discord:reset_commands`

Starting the bot:
`bundle exec rake discord:start_bot`

Be aware that it is possible to start the bot multiple times at once, and this could cause issues. Be sure to only run one bot at a time.

This application is using `sidekiq` to run jobs.
Running sidekiq:
`bundle exec sidekiq -c 2 -q default`

# Optional Functionality

The Discord bot can run without the admin panel or Slackbot, those are optional features included with the project.

## Admin Panel

The admin panel allows you to manage puzzles and is set up with Google OAuth for authentication by default.

To run the admin panel with google, you'll need to create a google oauth client to get the client ID and secret.

Go to [Google Cloud Console](https://console.cloud.google.com/apis/credentials) and create a new OAuth 2.0 client ID.
Set the redirect URI to `http://localhost:3000/auth/google_oauth2/callback` for local development.
Copy the client ID and secret to your `.env` file as `GOOGLE_CLIENT_ID` and `GOOGLE_CLIENT_SECRET`.

Run the Rails server:

`bundle exec rails server`
-or-
`bundle exec rails s`

## Slackbot

The Slackbot supports a slash command to suggest new puzzles and notifications when running low on puzzles (less then 5 approved puzzles).

To set up the Slackbot, you'll need to create a Slack app:

1. Go to [Slack API](https://api.slack.com/apps) and create a new app.
2. Add a slash command (e.g., `/suggest_puzzle`) and set the endpoint of the request URL to `/slack/new_puzzle`.
3. Configure `Interactivity & Shortcuts` to point to the `/slack/puzzle` endpoint.
4. Install the Slack app to your workspace and add the bot token and secret to the `.env` file as `SLACK_TOKEN` and `SLACK_SIGNING_SECRET`.
5. To use the notifications feature, also set the `SLACK_NOTIFICATIONS_CHANNEL` in the `.env` file with the channel ID where you want to receive notifications.
6. Optionally, you can also tag a specific Slack user group in the notification, just set the `SLACK_GROUP_ID` in the `.env` file with the group ID.

Slack sends POST requests to the specified URLs, for local development, you can use a tool like [ngrok](https://ngrok.com/) to expose your local server to the internet.
Use the ngrok URL as the request URL for the slash command and interactivity in your Slack app settings.

The Slackbot will be ready to use once you have set up the Slack app and configured the environment variables. Make sure the Rails server is running.
