class AddFieldsToAdminUser < ActiveRecord::Migration[6.0]
  def change
    add_column :admin_users, :reputation, :string, default: ""
    add_column :admin_users, :suspicious, :boolean, default: false
    add_column :admin_users, :references, :integer, default: ""
  end
end
