module EmailReps
  # Eg call:
  # => EmailReps::UpdateAdminUserRepTransaction.run.(email: 'admin@example.com')
  class UpdateAdminUserRepTransaction < ApplicationTransaction
    include Dry::Transaction

    step :get_email_reputation
    step :update_admin_user_rep

    private

    def get_email_reputation(input)
      service = EmailRepGateway.new.get_email_rep(email: input[:email])

      if service.success?
        Success(service.value!)
      else
        Failure(service.failure)
      end
    end

    def update_admin_user_rep(input)
      admin_user = AdminUser.find_by(email: input['email'])

      if admin_user
        admin_user.update(input.slice('reputation', 'suspicious', 'references'))
        Success({ admin_user: admin_user })
      else
        Failure(error: :not_found)
      end
    end

  end
end
