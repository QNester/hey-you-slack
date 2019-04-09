require 'hey-you'
require 'hey_you_slack/version'
require_relative 'hey_you/config/slack'
require_relative 'hey_you/builder/slack'
require_relative 'hey_you/channels/slack'

module HeyYouSlack
  CHANNEL_NAME = 'slack'.freeze

  HeyYou::Config.instance.registrate_channel(CHANNEL_NAME)
end
