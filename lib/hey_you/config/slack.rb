module HeyYou
  class Config
    class Slack
      extend Configurable
      attr_accessor :webhooks, :slack_username

      DEFAULT_USERNAME = 'Hey, you'.freeze

      def initialize
        @slack_username = DEFAULT_USERNAME
      end
    end
  end
end