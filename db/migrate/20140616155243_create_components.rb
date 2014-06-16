class CreateComponents < ActiveRecord::Migration
  def change
    create_table :components do |t|
      t.string :title
      t.boolean :harmful
      t.boolean :allergen

      t.timestamps
    end
  end
end
