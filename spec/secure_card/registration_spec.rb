require 'spec_helper'
require 'active_support/core_ext/numeric'

describe WorldnetTps::Request::SecureCard::Registration do

  let(:visa) { '4000060000000006' }
  let(:master_card) { '5001650000000000' }


  let(:merchant_ref) { 'worldnet_tps.gem' }
  let(:attributes) do
    {
      card_number: visa,
      card_type: 'VISA',
      card_expiry: '1234', #december 2034
      cvv: '111',
      card_holder_name: 'John Doe',
      merchant_ref: merchant_ref
    }
  end

  let(:operation) do
    gateway.secure_card_registration(attributes)
  end

  it 'should be valid object' do
    expect(operation).to be_a_kind_of(WorldnetTps::Request::SecureCard::Registration)
    expect(operation.gateway).to eq(gateway)
  end

  shared_examples :successful_response do
    it 'should be success' do
      expect(subject).to be_kind_of(WorldnetTps::Response::Success)
      expect(subject).to be_success
    end

    it 'should have valid data' do
      expect(subject.attributes).to(
        match(
          a_hash_including(
            card_reference: be_present,
            date_time: be_present,
            hash: be_present,
            merchant_ref: merchant_ref
          )
        )
      )
    end
  end

  describe '.create!' do

    let(:vcr_cassette) { 'secure_card/registration/registration_success' }

    subject do
      VCR.use_cassette(vcr_cassette, match_requests_on: [:method, :uri, :body]) do
        operation.create!
      end
    end

    include_examples :successful_response

    context 'when response failed' do
      let(:vcr_cassette) { 'secure_card/registration/registration_failed' }
      it_behaves_like :failed_response do
        it 'should contain error code' do
          expect(subject.code).to be_present
        end
      end
    end

  end

  describe '.update!' do
    let(:vcr_cassette) { 'secure_card/registration/update_success_success' }

    let(:attributes) {
      super().merge(card_number: master_card, card_type: 'MASTERCARD')
    }

    subject do
      VCR.use_cassette(vcr_cassette, match_requests_on: [:method, :uri, :body]) do
        operation.update!
      end
    end

    include_examples :successful_response

    context 'when response failed' do
      let(:vcr_cassette) { 'secure_card/registration/update_failed' }
      it_behaves_like :failed_response do
        it 'should contain error code' do
          expect(subject.code).to be_present
        end
      end
    end
  end
end