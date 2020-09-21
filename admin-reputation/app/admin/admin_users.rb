ActiveAdmin.register AdminUser do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    id_column
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :reputation
    column :suspicious
    column :references
    column :created_at
    actions defaults: true do |admin_user|
      link_to "Check reputation", admin_email_reputation_path(admin_user), method: :patch
    end
  end

  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :reputation
  filter :suspicious
  filter :references
  filter :created_at

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    def email_reputation
      @admin_user = AdminUser.find(params[:id])
      result = EmailReps::UpdateAdminUserRepTransaction.run.(email: @admin_user.email)

      if result.failure?
        flash[:error] = 'Check reputation failed: ' + result.failure[:response]['reason']
      end
      redirect_to admin_admin_user_url(@admin_user)
    end
  end

end
