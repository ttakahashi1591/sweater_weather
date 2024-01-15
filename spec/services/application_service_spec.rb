require 'rails_helper'

RSpec.describe ApplicationService do
  describe '#json_parse' do
    let(:service) { ApplicationService.new }

    it 'can parse a JSON response correctly' do
      response_body = '{"key": "value"}'
      response_double = double('FaradayResponse', body: response_body)

      allow(service).to receive(:json_parse).and_call_original

      parsed_result = service.json_parse(response_double)

      expect(parsed_result).to eq({ key: 'value' })
    end
  end
end