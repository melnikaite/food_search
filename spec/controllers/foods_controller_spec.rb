require 'rails_helper'

RSpec.describe FoodsController, :type => :controller do
  before do
    Rails.cache.clear
  end

  it 'should show search results' do
    food = FactoryGirl.create(:food)
    food.components << FactoryGirl.create(:component)
    Food.reindex
    post :index
    assert_response :success
    result = JSON.parse(response.body)
    result[0]['id'].should == food.id
  end
end
