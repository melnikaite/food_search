require 'open-uri'

class CollectFood
  FOOD_TYPES = {
    :cat => 1,
    :dog => 2
  }

  class << self
    def perform
      FOOD_TYPES.each do |food_type, food_type_id|
        #TODO: remove removed food
        CollectFood.list_of_food(food_type_id).each do |parsed_food|
          food = Food.find_or_create_by(title: parsed_food[:title], :food_type => food_type)
          #TODO: remove removed components
          CollectFood.components(parsed_food[:external_id]).each do |component|
            food.components << Component.find_or_create_by(component)
          end
        end
      end
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
      doc.css('[href^="fone"]').map do |a|
        {
          title: a.text,
          harmful: a.css('font').try(:[], 0).try(:[], 'color') == '#FF0000',
          allergen: a.next.text == '*'
        }
      end
    end

    #TODO: parse groups of components
    #TODO: parse english version
  end
end
