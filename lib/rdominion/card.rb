module Rdominion
  class Card
    attr_reader :cost, :description

    def self.color
      nil
    end

    def tresure?
      false
    end

    def name
      self.class.to_s.split("::").last
    end

    def action?
      false
    end

    def reaction?
      false
    end
  end

  class Tresure < Card
    attr_reader :coin

    def self.color
      "yellow"
    end

    def tresure?
      true
    end
  end

  StandardTresureCards = [
    {:name => :Copper, :cost => 0, :coin => 1, :description => "Worth 1 coins"},
    {:name => :Silver, :cost => 3, :coin => 2, :description => "Worth 2 coins"},
    {:name => :Gold, :cost => 6, :coin => 3, :description => "Worth 3 coins"}
  ]

  StandardTresureCards.each do |card|
    klass = self.const_set(card[:name], Class.new(Tresure))
    klass.class_eval do
      define_method("initialize") do
        @cost = card[:cost]
        @coin = card[:coin]
        @description = card[:description]
      end
    end
  end

  class Victory < Card
    attr_reader :victory

    def self.color
      "green"
    end
  end

  StandardVictoryCards = [
    {:name => :Estate, :cost => 2, :victory => 1, :description => "1 VP"},
    {:name => :Duchy, :cost => 5, :victory => 3, :description => "3 VP"},
    {:name => :Province, :cost => 8, :victory => 6, :description => "6 VP"}
  ]

  StandardVictoryCards.each do |card|
    klass = self.const_set(card[:name], Class.new(Victory))
    klass.class_eval do
      define_method("initialize") do
        @cost = card[:cost]
        @victory = card[:victory]
        @description = card[:description]
      end
    end
  end

  class StandardCurse < Card
    attr_reader :victory

    def self.color
      "magenta"
    end
  end

  StandardCurseCards = [
    {:name => :Curse, :cost => 0, :victory => -1, :description => "-1 VP"}
  ]

  StandardCurseCards.each do |card|
    klass = self.const_set(card[:name], Class.new(StandardCurse))
    klass.class_eval do
      define_method("initialize") do
        @cost = card[:cost]
        @victory = card[:victory]
        @description = card[:description]
      end
    end
  end

  class Action < Card
    def action?
      true
    end
  end

  class Reaction < Card
    # [Action - Reaction] Card
    def action?
      true
    end

    def reaction?
      true
    end
  end

  KingdomCards = [
    # CardName, CardClass, [Cost, Action, Buy, Coin, Card, Ability], description
    [:Market, :Action, [5, 1, 1, 1, 1], "+1 Card; +1 Action; +1 Buy; +1 Coin"],
    [:Remodel, :Action, [4, 0, 0, 0, 0, "remodel"], "Trash a card from your hand. Gain a card costing up to 2 Coins more than the trashed card."],
    [:Smithy, :Action, [4, 0, 0, 0, 3], "+3 Cards"],
    [:Moneylender, :Action, [4, 0, 0, 0, 0, "money_lender"], "Trash a Copper card from your hand. If you do, +3 Coins."],
    [:Woodcutter, :Action, [3, 0, 1, 2, 0], "+1 Buy; +2 Coins"],
    [:CouncilRoom, :Action, [5, 0, 1, 0, 4, "council_room"], "+4 Cards; +1 Buy; Each other player draws a card."],
    [:ThroneRoom, :Action, [4, 0, 0, 0, 0, "throne_room"], "Choose an Action card in your hand. Play it twice."],
    [:Laboratory, :Action, [5, 1, 0, 0, 2], "+2 Cards; +1 Action"],
    [:Mine, :Action, [5, 0, 0, 0, 0, "mine"], "Trash a Treasure card from your hand. Gain a Treasure card costing up to 3 Coins more; put it into your hand."],
    [:Workshop, :Action, [3, 0, 0, 0, 0, "workshop"], "Gain a card costing up to 4 Coins."],
    [:Chancellor, :Action, [3, 0, 0, 2, 0, "chancellor"], "+2 Coins; You may immediately put your deck into your discard pile."],
    [:Feast, :Action, [4, 0, 0, 0, 0, "feast"], "Trash this card. Gain a card costing up to 5 Coins."],
    [:Festival, :Action, [5, 2, 1, 2, 0], "+2 Actions; +1 Buy; +2 Coins"],
    [:Library, :Action, [5, 0, 0, 0, 0, "library"], "Draw until you have 7 cards in hand. You may set aside any Action cards drawn this way，as you draw them; discard the set aside cards after you finish drawing."],
    [:Cellar, :Action, [2, 1, 0, 0, 0, "cellar"], "+1 Action; Discard any number of cards. +1 Card per card discarded."],
    [:Gardens, :Victory, [4, 0, 0, 0, 0], "Worth 1 VP for every 10 cards in your deck (rounded down)."],
    [:Thief, :Action, [4, 0, 0, 0, 0, "thief"], "Each other player reveals the top 2 cards of his deck.  If they revealed any Treasure cards， they trash one of them that you choose. You may gain any or all of these trashed cards. They discard the other revealed cards."],
    [:Adventurer, :Action, [6, 0, 0, 0, 0, "adventurer"], "Reveal cards from your deck until you reveal 2 Treasure cards.  Put those Treasure cards in your hand and discard the other revealed cards. "],
    [:Moat, :Reaction, [2, 0, 0, 0, 2, "moat"], "+2 Cards; When another player plays an Attack card， you may reveal this from your hand. If you do, you are unaffected by that Attack."],
    [:Witch, :Action, [5, 0, 0, 0, 2, "witch"], "+2 Cards; Each other player gains a Curse card."],
    [:Spy, :Action, [4, 1, 0, 0, 1, "spy"], "+1 Card; +1 Action; Each player (including you) reveals the top card of his deck and either discards it or puts it back, your choice."],
    [:Militia, :Action, [4, 0, 0, 2, 0, "militia"], "+2 Coins; Each other player discards down to 3 cards in his hand."],
    [:Village, :Action, [2, 2, 0, 0, 1], "+1 Card; +2 Actions"],
    [:Bureaucrat, :Action, [4, 0, 0, 0, 0, "bureaucrat"], "Gain a silver card; put it on top of your deck. Each other player reveals a Victory card from his hand and puts it on his deck (or reveals a hand with no Victory cards)."],
    [:Chapel, :Action, [2, 0, 0, 0, 0, "chapel"], "Trash up to 4 cards from your hand."]
  ]

  KingdomCards.each do |card|
    name, super_klass, ablty, description = card
    super_klass = self.const_get(super_klass)
    klass = self.const_set(name, Class.new(super_klass))
    klass.class_eval do
      define_method("initialize") do
        @cost = ablty[0]
        @description = description
      end
      define_method("play") do
        { :action => ablty[1], :buy => ablty[2], :coin => ablty[3], :card =>ablty[4], :ability => ablty[5] }
      end
    end
  end
end
