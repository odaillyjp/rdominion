module Rdominion
  class CardAbility
    class << self
      def setting(players)
        @players = players
      end

      def remodel(player)
        card = trash(player).first
        get_supply(player, max_cost: card.cost + 2)
      end

      def money_lender(player)
        return false if trash(player, cancel: true, klass: Copper).nil?
        effect_log = player.add_bonus({:coin => 3})
        Log.add "#{player.name} #{effect_log}."
      end

      def chapel(player)
        trash(player, num: 4, cancel: true)
      end

      def witch(player)
        dist_curse(player)
      end

      private

      def trash(player, num: 1, cancel: false, klass: nil)
        return nil if klass && !player.has_hand_card?(klass)
        cards = []
        num.times do
          card = player.choose_hand_card(cancel: cancel, klass: klass)
          break if card.nil?
          player.trash_from_hand(card)
          cards.push(card)
        end
        cards
      end

      def get_supply(player, max_cost: 10)
        card = player.choose_supply_card(max_cost: max_cost)
        player.gain_to_discard(card)
      end

      def dist_curse(myself)
        @players.each do |player|
          next if player == myself
          player.gain_to_discard(Curse.new)
          Log.add "#{player.name} gain \"Curse\"."
        end
      end
    end
  end
end
