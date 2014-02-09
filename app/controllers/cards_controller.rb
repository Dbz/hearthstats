class CardsController < ApplicationController
  def index
    #update()
    @classes = Klass.order('name ASC');
    
    @cards = Card.order('name ASC')
    
    # filter by number of days to show
    @classFilter = CGI.parse(request.query_string)['class'].first
    if !@classFilter.nil? && (Float(@classFilter) rescue false)
     @cards = @cards.where('klass_id = ?', @classFilter)
    end
    
  end
  
  def update
    
    # set this to the card source URL
    source = "" 
    require 'net/http'
    @jsonResult = Net::HTTP.get(URI(source))
    require 'json'
    @hash = JSON.parse @jsonResult
    
    @hash.each do |cardData|
      card = Card.find(:first, :conditions => ['hearthhead_id = ?', cardData["hearthhead_id"]])
      if(card == nil)
        card = Card.new()
      end
      card.name = cardData["name"];
      card.description = cardData["description"];
      card.hearthhead_id = cardData["hearthhead_id"];
      card.set_id = cardData["set_id"];
      card.rarity_id = cardData["rarity_id"];
      card.type_id = cardData["type_id"];
      card.klass_id = cardData["class_id"];
      card.race_id = cardData["race_id"];
      card.mana = cardData["mana"];
      card.health = cardData["health"];
      card.attack = cardData["attack"];
      card.collectible = cardData["collectible"];
      card.save()
    end
    
  end
<<<<<<< HEAD
end
=======
end
>>>>>>> bd13da7b34473416d5445528c9ce9ccb2ef5bc16
