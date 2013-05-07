module Rdominion
  class StandardDeck
    def initialize
      @cards = []
    end

    def shuffle
      @cards.shuffle!
    end

    def add(cards)
      @cards.unshift(*cards)
    end

    def remove(card, to)
      to.add(card)
      @cards.delete(card)
    end

    def remove_all(to)
      to.add(@cards)
      @cards.clear
    end

    def get_card(idx)
      @cards[idx]
    end

    def size
      @cards.size
    end

    def display
      Display.addinfo "[ Your hand ]"
      @cards.each_with_index do |card, idx|
        alp_idx = (97 + idx).chr
        space = 20 - (card.name.size)
        text = "(#{alp_idx}) #{card.name}#{" " * space}[ #{card.cost} cost ] { #{card.description.truncate} }"
        text = "<!color:#{card.class.color}>#{text}<!/color>" if card.class.color
        Display.addstr(text)
      end
      Display.break
    end

    def oneline_list
      return "-" if @cards.size == 0
      @cards.reverse.inject("") { |sum, card| [sum, card.name].join(" ") }
    end
  end

  class Deck < StandardDeck
    def initialize
      super
      setting
    end

    def draw(num = 1, discard)
      before_size = @cards.size
      draw_cards = @cards.shift(num)
      [draw_cards].flatten
      if (before_size < num) && (discard.size > 0)
        reset(discard)
        draw_cards.concat(@cards.shift(num - before_size))
      end
      draw_cards
    end

    private

    def setting
      7.times { @cards.push(Copper.new) }
      3.times { @cards.push(Estate.new) }
      shuffle
    end

    def reset(discard)
      discard.remove_all(self)
      shuffle
    end
  end
end
