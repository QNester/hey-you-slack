require 'spec_helper'

RSpec.describe HeyYou::Builder::Slack do
  include_examples :have_readers, :username, :text, :icon_emoji, :icon_url, :webhook_name
end