require 'rails_helper'

RSpec.describe Search do
  it 'should search without options' do
    food = FactoryGirl.create(:food)
    Food.reindex

    expect(
      JSON.parse(Search.new().results).map{|r| r['id']}
    ).to match_array([food.id])
  end

  it 'should search by id' do
    foods = FactoryGirl.create_list(:food, 2)
    Food.reindex

    expect(
      JSON.parse(Search.new(ids: [foods.first.id]).results).map{|r| r['id']}
    ).to match_array([foods.first.id])
  end

  it 'should search by food type' do
    component = FactoryGirl.create(:component)
    cat_food = FactoryGirl.create(:food, food_type: :cat)
    dog_food = FactoryGirl.create(:food, food_type: :dog)
    cat_food.components << component
    dog_food.components << component
    Food.reindex

    expect(
      JSON.parse(Search.new(food_types: ['dog']).results).map{|r| r['food_type']}
    ).to match_array(['dog'])

    expect(
      JSON.parse(Search.new(food_types: ['dog', 'cat']).results).map{|r| r['food_type']}
    ).to match_array(['dog', 'cat'])
  end

  it 'should search by excluding components' do
    foods = FactoryGirl.create_list(:food, 2)
    components = FactoryGirl.create_list(:component, 2)
    foods.first.components << components.first
    foods.last.components << components.last
    Food.reindex

    expect(
      JSON.parse(Search.new(without_components: [components.first.id]).results).map{|r| r['id']}
    ).to match_array([foods.last.id])
  end

  it 'should search by excluding harmful components' do
    harmful = FactoryGirl.create(:food)
    harmful.components << FactoryGirl.create(:component, harmful: true)
    not_harmful = FactoryGirl.create(:food)
    not_harmful.components << FactoryGirl.create(:component, harmful: false)
    Food.reindex

    expect(
      JSON.parse(Search.new(without_harmful: true).results).map{|r| r['id']}
    ).to match_array([not_harmful.id])

    expect(
      JSON.parse(Search.new(without_harmful: false).results).map{|r| r['id']}
    ).to match_array([harmful.id, not_harmful.id])
  end

  it 'should search by excluding allergen' do
    allergic = FactoryGirl.create(:food)
    allergic.components << FactoryGirl.create(:component, allergen: true)
    not_allergic = FactoryGirl.create(:food)
    not_allergic.components << FactoryGirl.create(:component, allergen: false)
    Food.reindex

    expect(
      JSON.parse(Search.new(without_allergen: true).results).map{|r| r['id']}
    ).to match_array([not_allergic.id])

    expect(
      JSON.parse(Search.new(without_allergen: false).results).map{|r| r['id']}
    ).to match_array([allergic.id, not_allergic.id])
  end
end
