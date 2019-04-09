require 'httparty'
require 'json'

module HeyYou
  module Channels
    class Slack < Base
      class << self
        def send!(builder, **options)
          raise CredentialsNotExists unless credentials_present?

          if options[:to]&.is_a?(String) || builder.slack&.webhook_name
            return send_to_webhook(builder, options)
          end

          send_to_multiple_webhooks(builder, options)
        end

        private

        def send_to_webhook(builder, **options)
          webhook = options[:to] || config.slack.webhooks[builder.slack.webhook_name.to_sym]
          make_request_to_webhook(builder.slack.webhook_name, webhook, builder)
        end

        def send_to_multiple_webhooks(builder, **options)
          webhooks = config.slack.webhooks
          if options[:to] && options[:to].is_a?(Hash)
            webhooks = options[:to]
          end

          webhooks.each do |webhook_name, webhook|
            make_request_to_webhook(webhook_name, webhook, builder)
          end
        end

        def make_request_to_webhook(webhook_name, webhook, builder)
          config.logger&.info("Send notification to webhook #{webhook_name}")
          response = HTTParty.post(
            webhook,
            body: builder.slack.to_hash.to_json,
            :headers => {
              'Content-Type' => 'application/json',
              'Accept' => 'application/json'
            },
            debug_output: $stdout
          )
          config.logger&.info("Response from slack: #{response.body}")
          return { success: true } if response.body == 'ok'
          { success: false }
        end

        def required_credentials
          [:webhooks]
        end
      end
    end
  end
end