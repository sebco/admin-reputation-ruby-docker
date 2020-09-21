require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  describe 'Database stuff' do
    it { should have_db_column(:id).of_type(:integer) }
    it { should have_db_column(:email).of_type(:string) }
    it { should have_db_column(:encrypted_password).of_type(:string) }
    it { should have_db_column(:remember_created_at).of_type(:datetime) }
    it { should have_db_column(:reset_password_sent_at).of_type(:datetime) }
    it { should have_db_column(:reset_password_token).of_type(:string) }
    it { should have_db_column(:reputation).of_type(:string) }
    it { should have_db_column(:suspicious).of_type(:boolean) }
    it { should have_db_column(:references).of_type(:integer) }
    it { should have_db_column(:created_at).of_type(:datetime) }
    it { should have_db_column(:updated_at).of_type(:datetime) }

    it { should have_db_index(:email).unique(true) }
    it { should have_db_index(:reset_password_token).unique(true) }
  end
end
