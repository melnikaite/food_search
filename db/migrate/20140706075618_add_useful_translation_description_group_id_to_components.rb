class AddUsefulTranslationDescriptionGroupIdToComponents < ActiveRecord::Migration
  def change
    add_column :components, :useful, :boolean
    add_column :components, :translation, :string
    add_column :components, :description, :text
    add_reference :components, :group, index: true
  end
end
