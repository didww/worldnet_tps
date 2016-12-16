require 'spec_helper'

describe WorldnetTps::Request::SecureCard::Removal do


  let(:vcr_cassette) { 'secure_card/removal/success' }


  let(:merchant_ref) { 'worldnet_tps.gem' }
  let(:operation) do
    gateway.secure_card_removal(merchant_ref, '2967539209767734')
  end

  it 'should be valid object' do
    expect(operation).to be_a_kind_of(WorldnetTps::Request::SecureCard::Removal)
    expect(operation.gateway).to eq(gateway)
  end

  describe '.invoke!' do
    subject do
      VCR.use_cassette(vcr_cassette, match_requests_on: [:method, :uri, :body]) do
        operation.invoke!
      end
    end
    it 'should be success' do
      expect(subject).to be_kind_of(WorldnetTps::Response::Success)
      expect(subject.success?).to eq(true)
    end

    it 'should have valid data' do
      expect(subject.attributes).to(
        match(
          a_hash_including(
            date_time: be_present,
            hash: be_present,
            merchant_ref: merchant_ref
          )
        )
      )
      expect(subject).to be_success
    end

    context 'when response failed' do
      let(:vcr_cassette) { 'secure_card/removal/failed' }
      it_behaves_like :failed_response do
        it 'should contain error code' do
          expect(subject.code).to be_present
        end
      end
    end



  end

end