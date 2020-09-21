require 'rails_helper'

RSpec.describe EmailReps::UpdateAdminUserRepTransaction do
  let(:admin_user) { create :admin_user, email: 'admin@example.com' }
  subject(:transaction) { described_class.run }

  context 'when the user admin exists', vcr: { cassette_name: 'transactions/email_reps/get_email_rep_success' } do
    it 'returns admin user with updated attributes' do
      expect { transaction.call({ email: admin_user.email }) }
        .to change { admin_user.reload.attributes.slice('reputation', 'references') }
    end
  end

  context 'when the user admin does not exist', vcr: { cassette_name: 'transactions/email_reps/get_email_rep_failure' } do
    it 'returns failure' do
      result = transaction.call({ email: '123@email.com' })

      expect(result).to be_a(Dry::Monads::Failure)
      expect(result.failure).to include(error: :not_found)
    end
  end
end
