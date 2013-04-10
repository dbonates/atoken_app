class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :password_digest
      t.string :username
      t.string :email
      t.string :auth_token
      t.boolean :assinante
      t.datetime :auth_token_expires_at

      t.timestamps
    end
  end
end
