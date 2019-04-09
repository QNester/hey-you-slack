require 'spec_helper'

RSpec.describe HeyYou::Config::Slack do
  before do
    described_class.instance.instance_variable_set(:@configured, false)
    described_class.instance.instance_variable_set(:@webhooks, nil)
  end

  include_examples :singleton

  describe 'attributes' do
    include_examples :have_accessors, :webhooks, :slack_username
  end
end