RSpec.describe HeyYouSlack do
  it { expect(HeyYouSlack).to be_instance_of(Module) }
  it { expect(HeyYouSlack::VERSION).to be_instance_of(String) }
end