require 'spec_helper'
describe WorldnetTps::XSD do

  describe '.validate!' do
    let(:xml) do
      %q{
        <REFUND>
          <UNIQUEREF>KR3XSVSZ41</UNIQUEREF>
          <TERMINALID>6003</TERMINALID>
          <AMOUNT>10.50</AMOUNT>
          <DATETIME>10-12-2016:12:00:00:000</DATETIME>
          <OPERATOR>John</OPERATOR>
          <REASON>Product is defective</REASON>
        </REFUND>
        }
    end

    subject do
      described_class.validate!(xml)
    end

    it 'should raise exception' do
      expect { subject }.to raise_error(WorldnetTps::XSD::Error) do |error|
        expect(error.message).to eq("Element 'OPERATOR': This element is not expected. Expected is ( HASH ).")
        expect(error.internal_error).to be_a_kind_of(Nokogiri::XML::SyntaxError)
      end
    end
  end

end