class CreateJoinTableFoodComponents < ActiveRecord::Migration
  def change
    create_join_table :foods, :components
  end
end
