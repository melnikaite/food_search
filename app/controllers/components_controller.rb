class ComponentsController < ApplicationController
  def index
    components = Rails.cache.fetch('components', expires_in: 1.week) do
      Oj.dump(Component.all)
    end

    render json: components
  end
end
