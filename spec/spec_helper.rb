$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'worldnet_tps'
require 'vcr'



module  WorldnetTpsSharedContext
  extend RSpec::SharedContext

  before do
    allow(described_class).to receive(:current_date_time).and_return(date_time)
  end

  let(:date_time) { DateTime.parse('2016-12-10 12:00:00').utc.strftime('%d-%m-%Y:%H:%M:%S:000') }
  let(:gateway) { SandboxCredentials.gateway }


  shared_examples :failed_response do
    it 'should return error object' do
      expect(subject.success?).to eq(false)
      expect(subject.message).to be_present
      expect(subject).not_to be_success
    end
  end

  class SandboxCredentials
    def self.attributes
      HashWithIndifferentAccess.new(
        currency: 'USD',
        gateway: :worldnet,
        terminal_id: 6003,
        environment: :sandbox,
        shared_secret: 'sandboxUSD'
      )
    end
    def self.gateway
      WorldnetTps::Gateway.new(attributes)
    end
  end



end

RSpec.configure do |config|
  config.include WorldnetTpsSharedContext
end

VCR.configure do |config|
  config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
  config.hook_into :webmock
end