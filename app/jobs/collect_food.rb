require 'open-uri'

class CollectFood
  class << self
    def perform
      CollectFood.list_of_food.each do |parsed_food|
        food = Food.find_or_create_by(title: parsed_food[:title])
        #TODO: remove removed components
        CollectFood.components(parsed_food[:external_id]).each do |component|
          food.components << Component.find_or_create_by(title: component)
        end
      end
    end

    #TODO: parse animal type
    def list_of_food
      doc = Nokogiri::HTML(open('http://www.companionline.ru/fanalyser.php'))
      doc.css('select').first.css('option').map do |o|
        {
          external_id: o.text,
          title: o['value']
        }
      end.keep_if do |parsed_food|
        parsed_food[:external_id] != '0'
      end
    end

    #TODO: parse other fields
    def components(id)
      doc = Nokogiri::HTML(open("http://www.companionline.ru/fanalyser.php?f1id=#{id}"))
      doc.css('[href^="fone"]').map(&:text)
    end

    #TODO: parse groups of components
    #TODO: parse english version
  end
end
