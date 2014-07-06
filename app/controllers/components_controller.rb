class ComponentsController < ApplicationController
  def index
    components = Rails.cache.fetch('components') do
      Oj.dump(Component.all)
    end

    render json: components
  end
end
