class MainController < ApplicationController
  def index
  end

  def foods
    foods = Rails.cache.fetch("foods_#{params[:food_type]}", expires_in: 1.week) do
      Food.where(params[:food_type]).to_json
    end

    render json: foods
  end

  def components
    components = if params[:food]
                   Food.find_by_id(params[:food]).try(:components)
                 else
                   Rails.cache.fetch('components', expires_in: 1.week) do
                     Component.all.to_json
                   end
                 end

    render json: components
  end
end
