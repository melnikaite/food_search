class Search
  def initialize(without_components: [], without_harmful: false, without_allergic: false, food_types: [])
    @without_components = without_components
    @without_harmful = without_harmful
    @without_allergic = without_allergic
    @food_types = food_types
  end

  def where
    where = {}

    unless @food_types.blank?
      where[:'food_type'] = [@food_types]
    end

    unless @without_components.blank?
      where[:'components.id'] = {not: @without_components}
    end

    if @without_harmful
      where[:'components.harmful'] = {all: [false]}
    end

    if @without_allergic
      where[:'components.allergen'] = {all: [false]}
    end

    where
  end

  def results
    Food.search('*', load: false, where: where).results
  end
end
