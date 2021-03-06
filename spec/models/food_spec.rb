require 'rails_helper'

RSpec.describe Food, :type => :model do
  it { should have_and_belong_to_many(:components) }

  it 'should build data for index' do
    food = FactoryGirl.build(:food)
    component = FactoryGirl.build(:component)
    food.components << component
    expectation = {
      :id => nil,
      :title => 'food',
      :food_type => 'dog',
      :components => [
        {
          :group => 'group',
          :components_in_group => [
            {
              :id => nil,
              :title => 'component',
              :harmful => false,
              :allergen => false,
              :useful => false,
              :translation => 'translation',
              :description => 'description'
            }
          ]
        }
      ]
    }
    expect(food.search_data).to eq(expectation)
  end
end
