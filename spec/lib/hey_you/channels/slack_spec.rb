RSpec.describe HeyYou::Channels::Slack do
  let!(:config_webhooks) do
    h = {}
    for i in 3..10
      h["channel_name_#{i}".to_sym] = "https://default_webhook_#{i}.com"
    end
    h
  end
  let!(:config) { HeyYou::Config.instance }

  before do
    config.splitter = '.'
    klass = self
    config.registered_channels = [:slack]
    config.data_source.options = { collection_files: [TEST_FILE] }
    config.slack.webhooks = klass.config_webhooks
  end

  let!(:builder) { HeyYou::Builder.new('rspec.test_notification', pass_variable: FFaker::Lorem.word) }

  describe 'send!' do
    subject { described_class.send!(builder, to: to) }

    context 'pass :to option' do
      context ':to option as String' do
        let!(:to) { config_webhooks.keys.sample }

        it 'send only one request to webhook', focus: true do
          stub = stub_request(:post, config_webhooks[to]).with(body: builder.slack.to_hash)
          subject
          expect(stub).to have_been_requested
        end
      end

      context ':to option as Array' do
        let!(:to) { config_webhooks.keys }

        it 'send requests to webhooks' do
          stubs = to.map { |k| stub_request(:post, config_webhooks[k]).with(body: builder.slack.to_hash) }
          subject
          stubs.each { |stub| expect(stub).to have_been_requested }
        end
      end

      context ':to option as Hash' do
        let!(:to) { { config_webhooks.keys.first => config_webhooks.values.first } }

        it 'ignore :to option' do
          stubs = config_webhooks.map { |_, v| stub_request(:post, v).with(body: builder.slack.to_hash) }
          subject
          stubs.each { |stub| expect(stub).to have_been_requested }
        end
      end
    end

    context 'without :to option' do
      let!(:to) { nil }

      context 'webhook_name exists in notification collection' do
        let!(:builder) { HeyYou::Builder.new('rspec.test_notification_with_webhook', pass_variable: FFaker::Lorem.word) }

        it 'send only one request to webhook' do
          stub = stub_request(:post, config_webhooks[:channel_name_5]).with(body: builder.slack.to_hash)
          subject
          expect(stub).to have_been_requested
        end
      end

      context 'webhook_name not defined in notification collection' do
        it 'send only one request to webhook' do
          stubs = config_webhooks.map { |_, v| stub_request(:post, v).with(body: builder.slack.to_hash) }
          subject
          stubs.each { |stub| expect(stub).to have_been_requested }
        end
      end
    end
  end
end