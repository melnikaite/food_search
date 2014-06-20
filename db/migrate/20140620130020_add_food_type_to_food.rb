class AddFoodTypeToFood < ActiveRecord::Migration
  def change
    add_column :foods, :food_type, :string
  end
end
