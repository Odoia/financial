class CreateBankAccount < ActiveRecord::Migration[5.1]
  def change
    create_table :bank_accounts do |t|
      t.references :user
      t.float :amount

      t.timestamps
    end
  end
end
