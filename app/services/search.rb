class Search
  def initialize(without_components: [], without_harmful: false, without_allergic: false)
    @without_components = without_components
    @without_harmful = without_harmful
    @without_allergic = without_allergic
  end

  #TODO: search by type
  def where
    where = {}

    unless @without_components.blank?
      where[:'components.title'] = {not: @without_components}
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
