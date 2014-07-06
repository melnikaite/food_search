class Component < ActiveRecord::Base
  has_and_belongs_to_many :foods
  belongs_to :group

  def self.find_or_update_by_title(parsed_component)
    Marshal.load(
      Rails.cache.fetch("component_#{parsed_component[:title]}") do
        component = Component.find_or_initialize_by(title: parsed_component[:title])
        component.update(parsed_component)
        Marshal.dump(component)
      end
    )
  end
end
