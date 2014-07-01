require 'rails_helper'

RSpec.describe CollectFood, :vcr do
  it 'should parse list of food' do
    result = CollectFood.list_of_food(1)

    result[0].should == {external_id: '157', title: '1st Choice Adult Cat Chicken Formula'}
  end

  it 'should parse list of components' do
    result = CollectFood.components(157)

    result[0].should == {:title => 'Курица', :harmful => false, :allergen => false}
  end

  it 'should create structure of foods and components' do
    allow(CollectFood).to receive(:list_of_food).and_return([external_id: 1, title: 'title'])
    allow(CollectFood).to receive(:components).and_return([title: 'title', harmful: true, allergen: true])
    CollectFood.perform

    Food.count.should == 2
    Component.count.should == 1
    Component.first.foods.count.should == 2
  end
end
