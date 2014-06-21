class Food < ActiveRecord::Base
  has_and_belongs_to_many :components

  searchkick batch_size: 50

  scope :search_import, -> { includes(:components) }

  def search_data
    as_json(
      only: [
        :id,
        :title,
        :food_type,
      ],
      include: {
        components: {
          only: [
            :id,
            :title,
            :harmful,
            :allergen,
          ]
        }
      }
    )
  end
end
