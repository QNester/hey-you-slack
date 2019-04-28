# Hey, You, Slack!
[![Build Status](https://travis-ci.com/QNester/hey-you-slack.svg?branch=master)](https://travis-ci.com/QNester/hey-you-slack#)
[![Gem Version](https://badge.fury.io/rb/hey-you-slack.svg)](https://badge.fury.io/rb/hey-you-slack)

Slack notifications via [hey-you gem](https://github.com/QNester/hey-you).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hey-you-slack'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hey-you-slack

## Usage

After load gem you can send notifications to slack via [hey-you](https://github.com/QNester/hey-you).

For example:
```yaml
# config/notifications.yml
events:
  signed_up:
    # ...
    slack:
      username: Greeter
      text: 'User with email %{email} was signed up'
      webhook_name: 'channel_name' # key from config.slack.webhooks
      icon_emoji: ':grin:'
```

```ruby
# config/initalizers/hey-you.rb
HeyYou::Config.configure do 
	# [Hash] required - list of slack-webhooks for your applications 
  config.slack.webhooks = {
    channel_name: 'http://webhooks.slack/channel_webhook'
  } 
	
  # [String] optional - default name of author notifications messages in slack chats. 
  config.slack.slack_username = 'MyApp_Notifier'
end
```

```ruby
# // somewhere in your app 
builder = Builder.new('events.signed_up', email: created_user.email) 
HeyYou::Channels::Slack.send!(builder) #=> { success: true }
# Notification will be received in slack chat :)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. 
