class Food < ActiveRecord::Base
  has_and_belongs_to_many :components

  searchkick batch_size: 50

  scope :search_import, -> { includes(:components => :group) }

  def search_data
    {
      id: id,
      title: title,
      food_type: food_type,
      components: Group.cached_all.map do |group|
        {
          group: group.title,
          components_in_group: components.select{|c| c.group_id == group.id}.map do |c|
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
      end
    }
  end
end
