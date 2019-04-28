require 'json'

module HeyYou
  class Config
    class Slack
      extend Configurable
      attr_accessor :webhooks, :slack_username

      DEFAULT_USERNAME = 'Hey, you'.freeze

      def initialize
        @slack_username = DEFAULT_USERNAME
      end

      def webhooks=(webhooks_hash)
        return ArgumentError, 'webhooks must be a Hash' unless webhooks_hash.is_a?(Hash)

        @webhooks = webhooks_hash.inject({}) do |memo, (k, v)|
          memo[k.to_sym] = v
          memo
        end
      end
    end
  end
end