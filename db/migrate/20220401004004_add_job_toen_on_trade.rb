class AddJobToenOnTrade < ActiveRecord::Migration[5.1]
  def change
    add_column :trades, :job_token, :string
  end
end
