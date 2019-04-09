module HeyYou
  class Builder
    class Slack < Base
      attr_reader :username, :text, :icon_emoji, :icon_url, :webhook_name

      def build
        @webhook_name = ch_data.fetch('webhook_name', nil)
        @username = ch_data.fetch('username', nil) || Config.config.slack.slack_username
        @text = interpolate(ch_data.fetch('text'), options)
        @icon_emoji = ch_data.fetch('icon_emoji', nil)
        @icon_url = ch_data.fetch('icon_url', nil)
      end

      def to_hash
        excluded = [:@data, :@key, :@options]
        self.instance_variables.inject({}) do |memo, var|
          unless excluded.include?(var)
            memo[var.to_s.gsub('@', '')] = instance_variable_get(var)
          end
          memo
        end
      end
    end
  end
end