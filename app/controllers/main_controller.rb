class MainController < ApplicationController
  def index
  end

  def foods
    options = params.permit(
      {:without_components => []},
      :without_harmful,
      :without_allergic,
      :food_types
    ).symbolize_keys

    results = if options[:without_components]
                Oj.dump(Search.new(options).results.each{|f| f.delete('components')})
              else
                Rails.cache.fetch("foods_#{options}", expires_in: 1.week) do
                  Oj.dump(Search.new(options).results.each{|f| f.delete('components')})
                end
              end

    render json: results
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
