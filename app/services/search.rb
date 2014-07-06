class Search
  def initialize(ids: [], food_types: [], without_components: [], without_harmful: false, without_allergen: false)
    @ids = ids
    @food_types = food_types
    @without_components = without_components
    @without_harmful = without_harmful
    @without_allergen = without_allergen
  end

  def where
    where = {}

    unless @ids.blank?
      where[:'id'] = [@ids]
    end

    unless @food_types.blank?
      where[:'food_type'] = [@food_types]
    end

    unless @without_components.blank?
      where[:'components.components_in_group.id'] = {not: @without_components}
    end

    if @without_harmful
      where[:'components.components_in_group.harmful'] = {not: [true]}
    end

    if @without_allergen
      where[:'components.components_in_group.allergen'] = {not: [true]}
    end

    where
  end

  def results
    request = Food.search('*', load: false, where: where, execute: false)
    request.body[:_source] = {exclude: 'components.*'} if @ids.blank?
    results = request.execute.results
    Oj.dump(results)
  end
end
