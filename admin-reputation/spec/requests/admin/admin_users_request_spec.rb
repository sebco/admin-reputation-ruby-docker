require 'rails_helper'

RSpec.describe Admin::AdminUsersController, type: :request do
  let(:admin_user) { create :admin_user, email: 'admin@example.com' } 
  before { sign_in admin_user }
  let(:valid_attributes) do
    attributes_for :admin_user
  end
  let(:invalid_attributes) do
    { email: '' }
  end

  describe 'GET #index' do
    it 'returns http success' do
      get admin_admin_users_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET #new' do
    it 'returns http success' do
      get new_admin_admin_user_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'POST #create' do
    context 'with valid params' do
      it 'creates a new AdminUser' do
        expect { post admin_admin_users_path, params: { admin_user: valid_attributes } }
          .to change(AdminUser, :count).by(1)
      end

      it 'redirects to the created admin_user' do
        post admin_admin_users_path, params: { admin_user: valid_attributes }
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_admin_user_path(AdminUser.last))
      end

      it 'should create the admin_user' do
        post admin_admin_users_path, params: { admin_user: valid_attributes }
        au = AdminUser.last

        expect(au.email).to eq(valid_attributes[:email])
      end
    end

    context 'with invalid params' do
      it 'invalid_attributes return http success' do
        post admin_admin_users_path, params: { admin_user: invalid_attributes }
        expect(response).to have_http_status(:success)
      end

      it 'invalid_attributes do not create a AdminUser' do
        expect do
          post admin_admin_users_path, params: { admin_user: invalid_attributes }
        end.not_to change(AdminUser, :count)
      end
    end
  end

  describe 'GET #edit' do
    it 'returns http success' do
      get edit_admin_admin_user_path(admin_user.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'PUT #update' do
    context 'with valid params' do
      let(:updated_email) { 'updated@mail.com' }

      before do
        put admin_admin_user_path(admin_user.id), params: { admin_user: valid_attributes.merge(email: updated_email) }
      end

      it 'returns http redirect' do
        expect(response).to have_http_status(:redirect)
        expect(response).to redirect_to(admin_admin_user_path(admin_user))
      end

      it 'should update the admin_user' do
        admin_user.reload

        expect(admin_user.email).to eq(updated_email)
      end
    end
    context 'with invalid params' do
      it 'returns http success' do
        put admin_admin_user_path(admin_user.id), params: { admin_user: invalid_attributes }
        expect(response).to have_http_status(:success)
      end
    end
  end

  describe 'GET #show' do
    before do
      get admin_admin_user_path(admin_user.id)
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested admin user' do
      expect { delete admin_admin_user_path(admin_user.id) }
        .to change(AdminUser, :count).by(-1)
    end

    it 'redirects to the index' do
      delete admin_admin_user_path(admin_user.id)
      expect(response).to redirect_to(admin_admin_users_path)
    end
  end

  describe 'PUT #email_reputation' do
    context 'when success' do
      it 'updates the requested admin user attributes', vcr: { cassette_name: 'requests/admin/admin_users/email_reputation_success' } do
        expect { patch admin_email_reputation_path(admin_user.id) }
          .to change { admin_user.reload.attributes.slice('reputation', 'references') }
        expect(flash[:error]).to be_nil
        expect(response).to redirect_to(admin_admin_user_path(admin_user))
      end
    end

    context 'when failure' do
      it 'does not update the requested admin user attributes', vcr: { cassette_name: 'requests/admin/admin_users/email_reputation_failure' } do
        expect { patch admin_email_reputation_path(admin_user.id) }
          .not_to change { admin_user.reload.attributes.slice('reputation', 'references') }
        expect(flash[:error]).to be_present
        expect(response).to redirect_to(admin_admin_user_path(admin_user))
      end
    end
  end
end
