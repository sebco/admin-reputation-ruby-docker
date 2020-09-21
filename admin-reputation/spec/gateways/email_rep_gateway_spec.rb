require 'rails_helper'

RSpec.describe EmailRepGateway do
  describe "#get_email_rep" do
    context 'when success' do
      let(:email) { 'test@mail.com' }
      subject(:gateway) { described_class.new.get_email_rep(email: email) }

      it 'should return a success', vcr: { cassette_name: 'gateways/email_reps/get_email_rep_success' } do
        expect(gateway).to be_a(Dry::Monads::Success)
        expect(gateway.value!['email']).to eql(email)
        expect(gateway.value!['reputation']).to be_present
        expect(gateway.value!['suspicious']).to be_present
        expect(gateway.value!['references']).to be_present
      end
    end

    context 'when failure' do
      let(:email) { '123' }
      subject(:gateway) { described_class.new.get_email_rep(email: email) }

      it 'should return a failure', vcr: { cassette_name: 'gateways/email_reps/get_email_rep_failure' } do
        expect(gateway).to be_a(Dry::Monads::Failure)
        expect(gateway.failure.keys).to include(:error, :response)
        expect(gateway.failure[:response].keys).to include('status', 'reason')
      end
    end
  end
end
