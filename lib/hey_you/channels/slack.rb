require 'httparty'
require 'json'

module HeyYou
  module Channels
    class Slack < Base
      WEBHOOK_ERR_MSG_TMPL = "slack webhook `%{key}` was not configured".freeze

      class << self
        # @param [HeyYou::Builder] builder - builder with notifications texts and settings
        # @option [String/Symbol] to - key from `config.slack.webhooks` hash
        def send!(builder, **options)
          raise CredentialsNotExists unless credentials_present?

          if options[:to]&.is_a?(String) || options[:to]&.is_a?(Symbol)
            return send_to_webhook(builder, **options)
          end

          if builder.slack&.webhook_name
            options.delete(:to)
            return send_to_webhook(builder, **options)
          end

          send_to_multiple_webhooks(builder, **options)
        end

        private

        def send_to_webhook(builder, **options)
          hook_key = options[:to]&.to_sym || builder.slack.webhook_name.to_sym
          webhook = config.slack.webhooks[hook_key]

          if webhook == nil || webhook == ""
            raise WebhookError, WEBHOOK_ERR_MSG_TMPL % { key: hook_key }
          end

          [make_request_to_webhook(hook_key, webhook, builder)]
        end

        def send_to_multiple_webhooks(builder, **options)
          webhooks = config.slack.webhooks

          if options[:to]&.is_a?(Array)
            begin
              webhooks = config.slack.webhooks.dup.keep_if { |k, _| options[:to].include?(k) }
            rescue KeyError => err
              raise WebhookError, WEBHOOK_ERR_MSG_TMPL % { key: err.key }
            end
          end

          webhooks.map do |webhook_name, webhook|
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
            }
          )
          config.logger&.info("Response from slack: #{response.body}")
          { webhook_name => response.body == 'ok' }
        end

        def required_credentials
          [:webhooks]
        end
      end
      class WebhookError < StandardError; end
    end
  end
end