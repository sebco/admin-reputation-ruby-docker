Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  namespace :admin do
    patch 'admins_users/:id/email_reputation' => 'admin_users#email_reputation', as: :email_reputation
  end

  root 'pages#home'
end
