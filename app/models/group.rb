class Group < ActiveRecord::Base
  has_many :components

  def self.find_or_create_by_title(title)
    Marshal.load(
      Rails.cache.fetch("group_#{title}") do
        Marshal.dump(
          Group.find_or_create_by(title: title)
        )
      end
    )
  end

  def self.cached_all
    Marshal.load(
      Rails.cache.fetch('all_groups') do
        Marshal.dump(
          Group.all
        )
      end
    )
  end
end
