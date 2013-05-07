module Rdominion
  class CardAbility
    class << self
      def setting(players)
        @player_1 = players[0]
        @player_2 = players[1]
      end

      def remodel(player)
        card = trash(player)
        get_supply(player, card.cost + 2)
      end

      private

      def trash(player)
        card = player.choose_hand_card
        player.trash_from_hand(card)
      end

      def get_supply(player, max_cost)
        card = player.choose_supply_card(max_cost: max_cost)
        player.gain_to_discard(card)
      end
    end
  end
end
