require "rdominion/card_ability"
require "rdominion/command"

module Rdominion
  class Player
    attr_reader :name, :action, :buy, :coin
    @@trash = StandardDeck.new
    @@supply = Supply.new
    include Command

    def initialize(name)
      @name = name
      @discard = StandardDeck.new
      @deck = Deck.new
      @hand = StandardDeck.new
      @play_area = StandardDeck.new
      clean_up
    end

    def clean_up
      @action = 1
      @buy = 1
      @coin = 0
      @play_area.remove_all(@discard)
      @hand.remove_all(@discard)
      @hand.add(@deck.draw(5, @discard))
    end

    def play_action(idx)
      return false if @action <= 0
      card = @hand.get_card(idx)
      return false if card.nil?
      unless card.action?
        Display.caution "\"#{card.name}\": Card not action."
        Display.backline
        return false
      end
      @action -= 1
      effects = card.play
      @hand.remove(card, @play_area)
      effect_log = add_bonus(effects)
      Log.add "#{@name} plays \"#{card.name}\": #{effect_log}"
      CardAbility.send(effects[:ability], self) if effects[:ability]
      true
    end

    def play_tresure_all
      tresure_cards = []
      max_size = @hand.size
      max_size.times do |idx|
        card = @hand.get_card(idx)
        tresure_cards.push(card)  if card.tresure?
      end
      tresure_cards.each do |card|
        @hand.remove(card, @play_area)
        @coin += card.coin
      end
      tresure_cards.map(&:name).uniq.each do |card_name|
        count = tresure_cards.count { |card| card.name == card_name }
        Log.add "#{@name} #{count} plays \"#{card_name}\"."
      end
    end

    def add_bonus(effects)
      effect_logs = []
      [:action, :coin, :buy].each do |target|
        if effects[target] && effects[target] > 0
          eval("@#{target} += effects[target]", binding)
          eval("effect_logs.push(\"+#{effects[target]} #{target.to_s}\")", binding)
        end
      end
      if effects[:card] && effects[:card] > 0
        cards = @deck.draw(effects[:card], @discard)
        @hand.add(cards)
        cards.each { |card| effect_logs.push("draw \"#{card.name}\"") }
      end
      effect_logs.join("; ")
    end

    def hand_commands
      get_commands(@hand)
    end

    def supply_commands
      get_commands(@@supply)
    end

    def show_hand
      @hand.display
    end

    def show_supply
      @@supply.display
    end

    def show_status
      Display.add_info "[ #{@name} ]"
      Display.add_text "#{@action} Action | #{@buy} Buy | #{@coin} Coin | #{@hand.size} Hand | #{@deck.size} Deck | #{@discard.size} Discard"
      Display.add_text "Used: #{@play_area.oneline_list}"
      Display.add_break
    end

    def buy_supply(idx)
      if @@supply.cost(idx) > @coin
        Display.caution "\"#{@@supply.get_card_name(idx)}\" Not enough coin."
        Display.backline
        return false
      end
      return false unless supply_stock?(idx)
      card = @@supply.get_card(idx)
      @buy -= 1
      @coin -= card.cost
      @@supply.remove(card, @discard)
      Log.add "#{@name} buys \"#{card.name}\"."
      true
    end

    def supply_stock?(idx)
      if @@supply.stock(idx) == 0
        Display.caution "\"#{@@supply.get_card_name(idx)}\" No stock."
        Display.backline
        return false
      end
      true
    end

    def has_hand_card?(klass)
      @hand.has_card?(klass)
    end

    def choose_hand_card(cancel: false, klass: nil)
      Display.clear
      Log.show(3)
      @hand.display
      Display.notice "< Press Card Index >"
      Display.notice "< Press ENTER KEY - Done Choose >" if cancel
      cmds = get_commands(@hand)
      loop do
        key = Display.getch
        return nil if cancel && key == KEY_ENTER
        unless cmds.include?(key)
          command_not_found(key)
          next
        end
        card = @hand.get_card(key.to_idx)
        if klass && !card.is_a?(klass)
          Display.caution "\"#{card.name}\" Not equal \"#{klass.to_s}\"."
          next
        end
        return card
      end
    end

    def choose_supply_card(max_cost: nil)
      Display.clear
      Log.show(3)
      @@supply.display
      Display.notice "< Press Supply Index >"
      cmds = get_commands(@@supply)
      idx = nil
      loop do
        key = Display.getch
        unless cmds.include?(key)
          command_not_found(key)
          next
        end
        idx = key.to_idx
        if max_cost && @@supply.cost(idx) > max_cost
          Display.caution "\"#{@@supply.get_card_name(idx)}\" Costs over. You choose card costing up to #{max_cost} Coins."
          Display.backline
          next
        end
        return @@supply.get_card(idx) if supply_stock?(idx)
      end
    end

    def gain_to_discard(card)
      return nil unless @@supply.remove(card, @discard)
      Log.add "#{@name} gain \"#{card.name}\"."
      card
    end

    def trash_from_hand(card)
      return nil unless @hand.remove(card, @@trash)
      Log.add "#{@name} trashs \"#{card.name}\"."
      card
    end

    private

    def get_commands(target)
      ("a".."z").to_a.shift(target.size)
    end
  end
end
