RSpec.describe HeyYou::Channels::Slack do
  let!(:default_webhooks) do
    {
      channel_name_1: 'https://default_webhook_1.com',
      channel_name_2: 'https://default_webhook_2.com',
    }
  end
  let!(:webhooks) do
    {
      channel_name_1: 'https://webhook_url_1.com',
      channel_name_2: 'https://webhook_url_2.com',
    }
  end

  before do
    HeyYou::Config.instance.instance_variable_set(:@splitter, '.')
    klass = self
    HeyYou::Config.configure do
      config.registered_channels = [:slack]
      config.collection_files = TEST_FILE
      config.slack.webhooks = klass.default_webhooks
    end
  end

  let!(:builder) { HeyYou::Builder.new('rspec.test_notification', pass_variable: FFaker::Lorem.word) }

  describe 'send!' do
    subject { described_class.send!(builder, to: to) }

    context 'pass :to option' do
      context ':to option as String' do
        let!(:to) { webhooks[:channel_name_1] }

        it 'send only one request to webhook' do
          stub = stub_request(:post, to).with(body: builder.slack.to_hash)
          subject
          expect(stub).to have_been_requested
        end
      end

      context ':to option as Hash' do
        let!(:to) { webhooks }

        it 'send requests to webhooks' do
          stub_1 = stub_request(:post, to[:channel_name_1]).with(body: builder.slack.to_hash)
          stub_2 = stub_request(:post, to[:channel_name_2]).with(body: builder.slack.to_hash)
          subject
          expect(stub_1).to have_been_requested
          expect(stub_2).to have_been_requested
        end
      end

      context ':to option as Array' do
        let!(:to) { webhooks.values }

        it 'ignore :to option' do
          stub_1 = stub_request(:post, default_webhooks[:channel_name_1]).with(body: builder.slack.to_hash)
          stub_2 = stub_request(:post, default_webhooks[:channel_name_2]).with(body: builder.slack.to_hash)
          subject
          expect(stub_1).to have_been_requested
          expect(stub_2).to have_been_requested
        end
      end
    end

    context 'without :to option' do
      let!(:to) { nil }

      context 'webhook_name exists in notification collection' do
        let!(:builder) { HeyYou::Builder.new('rspec.test_notification_with_webhook', pass_variable: FFaker::Lorem.word) }

        it 'send only one request to webhook' do
          stub = stub_request(:post, default_webhooks[:channel_name_1]).with(body: builder.slack.to_hash)
          subject
          expect(stub).to have_been_requested
        end
      end

      context 'webhook_name not defined in notification collection' do
        it 'send only one request to webhook' do
          stub_1 = stub_request(:post, default_webhooks[:channel_name_1]).with(body: builder.slack.to_hash)
          stub_2 = stub_request(:post, default_webhooks[:channel_name_2]).with(body: builder.slack.to_hash)
          subject
          expect(stub_1).to have_been_requested
          expect(stub_2).to have_been_requested
        end
      end
    end
  end
end