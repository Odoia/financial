class CreateTrade < ActiveRecord::Migration[5.1]
  def change
    create_table :trades do |t|
      t.integer :trade_type, :account_id, :shares, :price, :state, :timestamp
      t.string :symbol

      t.timestamps
    end
  end
end
