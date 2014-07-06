class FoodsController < ApplicationController
  def index
    options = params
    .permit(
      {:ids => []},
      :food_types,
      {:without_components => []},
      :without_harmful,
      :without_allergen,
    )
    .symbolize_keys

    results = Rails.cache.fetch("foods_#{options}") do
      Search.new(options).results
    end

    render json: results
  end
end
