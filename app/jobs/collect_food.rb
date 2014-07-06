require 'open-uri'

class CollectFood
  FOOD_TYPES = {
    :cat => 1,
    :dog => 2
  }

  class << self
    def perform
      FOOD_TYPES.each do |food_type, food_type_id|
        list_of_food = CollectFood.list_of_food(food_type_id)
        Food.where(:food_type => food_type).where.not(title: list_of_food.collect{|f| f[:title]}).destroy_all
        list_of_food.each do |parsed_food|
          food = Food.includes(:components => :group).find_or_initialize_by(title: parsed_food[:title], :food_type => food_type)
          food.update(parsed_food.except(:external_id))
          list_of_components = CollectFood.components(parsed_food[:external_id])
          food.components.where.not(title: list_of_components.collect{|f| f[:title]}).destroy_all
          list_of_components.each do |parsed_component|
            next if parsed_component[:title].blank?
            group = Group.find_or_create_by_title(parsed_component[:group])
            component = Component.find_or_update_by_title(parsed_component.except(:group).merge({group_id: group.id}))
            food.components << component unless food.components.include?(component)
          end
        end
      end
      Food.reindex
    end

    def list_of_food(id)
      doc = Nokogiri::HTML(open("http://www.companionline.ru/fanalyser.php?do=display&type=#{id}"))
      doc.css('select').first.css('option').map do |o|
        {
          external_id: o['value'],
          title: o.text
        }
      end.keep_if do |parsed_food|
        parsed_food[:external_id] != '0'
      end
    end

    def components(id)
      doc = Nokogiri::HTML(open("http://www.companionline.ru/fanalyser.php?f1id=#{id}"))
      doc.search('[href^="fone"]').map do |a|
        color = a.search('font')[0]['color']
        popup = a.parent().next_element()
        {
          title: a.text,
          harmful: ['#FF0000', '#CC0000'].include?(color),
          useful: ['#339966', '#339900'].include?(color),
          allergen: a.next.text == '*',
          translation: popup.search('.tcat').text,
          description: popup.search('.smallfont').text.gsub("\r\n", ''),
          group: a.parent().parent().parent().previous_element().search('td')[0].text.strip,
        }
      end
    end
  end
end
