class Food < ActiveRecord::Base
  has_and_belongs_to_many :components

  searchkick batch_size: 50

  scope :search_import, -> { includes(:components => :group) }

  def search_data
    {
      id: id,
      title: title,
      food_type: food_type,
      components: components.group_by do |component|
        component.group.title
      end.map do |group, components_in_group|
        {
          group: group,
          components_in_group: components_in_group.map do |c|
            {
              id: c.id,
              title: c.title,
              harmful: c.harmful,
              allergen: c.allergen,
              useful: c.useful,
              translation: c.translation,
              description: c.description,
            }
          end
        }
      end.sort_by do |c|
        c['group']
      end
    }
  end
end
