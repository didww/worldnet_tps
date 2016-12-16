require 'spec_helper'

describe WorldnetTps::Request::Payment do

  let(:operation) do
    gateway.payment(payment_attributes)
  end

  let(:payment_attributes) do
    {
      amount: '10.50',
      order_id: 'TXN-124-55',
      post_code: '98104',
      email: 'john.doe@gmail.com',
      address1: '100 MAIN ST',
      address2: 'SEATTLE WA',
      phone: '2064960114',
      city: 'SEATTLE',
      country: 'US'
    }
  end



  subject do
    VCR.use_cassette(vcr_cassette, match_requests_on: [:method, :uri, :body]) do
      operation.invoke!
    end
  end


  it 'should be valid object' do
    expect(operation).to be_a_kind_of(WorldnetTps::Request::Payment)
    expect(operation.gateway).to eq(gateway)
  end

  describe '.invoke!' do
    context 'credit card' do

      let(:payment_attributes) do
        super().merge(
          card_number: '4000060000000006',
          card_type: 'VISA',
          card_expiry: '1223',
          card_holder_name: 'John Doe',
          cvv: '111',
          order_id: 'TXN-124-59',
        )
      end
      let(:vcr_cassette) { 'payment/credit_card/success' }
      it 'should have valid data' do
        expect(subject.attributes).to(
          match(
            a_hash_including(
              approval_code: be_present,
              date_time: be_present,
              hash: be_present,
              response_text: be_present,
              response_code: be_present
            )
          )
        )
        expect(subject).to be_success
      end
      context 'failed response' do
        let(:payment_attributes) do
          super().merge(
            card_number: '4000060000000006',
            card_type: 'UNSUPPORTED',
            order_id: 'TXN-124-56'
          )
        end
        let(:vcr_cassette) { 'payment/credit_card/failed' }
        it_behaves_like :failed_response
      end

    end

    context 'secure card' do
      let(:payment_attributes) do
        super().merge(
          card_number: '2967539270368883',
          card_type: WorldnetTps::Const::SECURECARD,
        )
      end
      let(:vcr_cassette) { 'payment/secure_card/success' }


      it 'should have valid data' do
        expect(subject.attributes).to(
          match(
            a_hash_including(
              approval_code: be_present,
              date_time: be_present,
              hash: be_present,
              response_text: be_present,
              response_code: be_present
            )
          )
        )
        expect(subject).to be_success
      end

      context 'failed response' do
        let(:vcr_cassette) { 'payment/secure_card/failed' }
        it_behaves_like :failed_response
      end


    end


  end

end