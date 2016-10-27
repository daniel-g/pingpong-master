class AddRatingToUser < ActiveRecord::Migration
  def change
    add_column :users, :rating, :integer, null: 0, default: 0
  end
end
