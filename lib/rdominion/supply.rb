module Rdominion
  class Supply
    def initialize
      setting
    end

    def display
      Display.addinfo "[ Supplies ]"
      @supplies.each_with_index do |supply, idx|
        alp_idx = (97 + idx).chr
        space = 20 - (supply[:stock].to_s.size + supply[:name].size)
        card_color = Rdominion::const_get(supply[:name]).color
        text = "(#{alp_idx}) #{supply[:stock]} #{supply[:name]}#{" " * space}[ #{supply[:cost ]} cost ] { #{supply[:description].truncate} }"
        text = "<!color:#{card_color}>#{text}<!/color>" if card_color
        Display.addstr(text)
      end
      Display.break
    end

    def buy(idx, player)
      return false if @supplies[idx][:stock] <= 0
      @supplies[idx][:stock] -= 1
      get_card(idx)
    end

    def get_card(idx)
      card_name = get_card_name(idx)
      Rdominion::const_get(card_name).new
    end

    def get_card_name(idx)
      @supplies[idx][:name]
    end

    def cost(idx)
      @supplies[idx][:cost]
    end

    def size
      @supplies.size
    end

    private

    def setting
      @supplies = KingdomCards.sample(10).map do |card|
        { :name => card[0], :stock => card_stock(card[1]), :cost => card[2][0], :description => card[3] }
      end
      @supplies.sort_by! { |supply| supply[:cost] }
      [StandardTresureCards, StandardVictoryCards, StandardCurseCards].each do |cards|
        tmp = cards.map do |card|
          {:name => card[:name], :stock => card_stock(card[:name]), :cost => card[:cost], :description => card[:description] }
        end
        @supplies.concat(tmp)
      end
    end

    def card_stock(klass)
      case klass
        when :Action, :Reaction then 10
        when :Copper then 50
        when :Silver then 40
        when :Gold then 30
        when :Victory, :Estate, :Duchy, :Province then 12
        when :Curse then 30
        else 8
      end
    end
  end
end
