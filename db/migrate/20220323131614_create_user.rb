class CreateUser < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :email, :password_digest, :name, :surname
      t.boolean :is_active, default: true

      t.timestamps
    end
  end
end
