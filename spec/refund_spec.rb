require 'spec_helper'

describe WorldnetTps::Request::Refund do

  let(:operation) do
    gateway.refund(refund_attributes)
  end

  let(:refund_attributes) do
    {
      amount: '10.50',
      operator: 'John',
      reason: 'Product is defective'
    }
  end


  it 'should be valid object' do
    expect(operation).to be_a_kind_of(WorldnetTps::Request::Refund)
    expect(operation.gateway).to eq(gateway)
  end



  subject do
    VCR.use_cassette(vcr_cassette, match_requests_on: [:method, :uri, :body]) do
      operation.invoke!
    end
  end

  describe '.invoke!' do

    include_context :xsd_validation

    context 'by order id' do

      let(:vcr_cassette) { 'refund/order_id/success' }
      let(:refund_attributes){
        super().merge(order_id: 'TXN-124-57')
      }
      it 'should have valid data' do
        expect(subject.attributes).to(
          match(
            a_hash_including(
              response_code: be_present,
              response_text: be_present,
              hash: be_present,
              order_id: be_present,
              date_time: be_present
            )
          )
        )
        expect(subject).to be_success
      end
      context 'failed response' do
        let(:vcr_cassette) { 'refund/order_id/failed' }
        it_behaves_like :failed_response
      end


    end


    context 'by unique_ref' do

      let(:vcr_cassette) { 'refund/unique_ref/success' }
      let(:refund_attributes){
        super().merge(unique_ref: 'KR3XSVSZ41')
      }
      it 'should have valid data' do
        expect(subject.attributes).to(
          match(
            a_hash_including(
              response_code: be_present,
              response_text: be_present,
              hash: be_present,
              unique_ref: be_present,
              date_time: be_present
            )
          )
        )

        expect(subject).to be_success
      end

      context 'failed response' do
        let(:vcr_cassette) { 'refund/unique_ref/failed' }
        it_behaves_like :failed_response
      end


    end
  end

end