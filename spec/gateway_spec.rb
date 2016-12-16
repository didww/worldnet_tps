require 'spec_helper'
describe WorldnetTps::Gateway do
  subject do
    WorldnetTps::Gateway.new(attributes)
  end

  let(:attributes) do
    WorldnetTpsSharedContext::SandboxCredentials.attributes
  end

  context 'production environment' do
    let(:attributes) do
      super().merge(environment: :production)
    end
    describe '.domain' do
      it 'should be live endpoint' do
        expect(subject.endpoint).to eq('https://payments.worldnettps.com')
      end

    end
    describe '.is_test?' do
      it 'should be false' do
        expect(subject.is_test?).to eq(false)
      end
    end
  end


  describe '.endpoint' do
    it 'should be sandbox endpoint' do
      expect(subject.endpoint).to eq('https://testpayments.worldnettps.com')
    end
  end

  describe '.is_test?' do
    it 'should be true' do
      expect(subject.is_test?).to eq(true)
    end
  end


end