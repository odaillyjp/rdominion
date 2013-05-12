require "rdominion/card_ability"

module Rdominion
  class Player
    attr_reader :name, :action, :buy, :coin
    @@trash = StandardDeck.new
    @@supply = Supply.new

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
        Display.warn "\"#{card.name}\": Card not action."
        Display.backline(2)
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
        if effects[target] > 0
          eval("@#{target} += effects[target]", binding)
          eval("effect_logs.push(\"+#{effects[target]} #{target.to_s}\")", binding)
        end
      end
      if effects[:card] > 0
        cards = @deck.draw(effects[:card], @discard)
        @hand.add(cards)
        cards.each { |card| effect_logs.push("get \"#{card.name}\"") }
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
        Display.warn "\"#{@@supply.get_card_name(idx)}\" Not enough coin."
        Display.backline(2)
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
        Display.warn "\"#{@@supply.get_card_name(idx)}\" No Stock."
        Display.backline(2)
        return false
      end
      true
    end

    def choose_hand_card
      Display.clear
      Log.show(3)
      @hand.display
      Display.notice "< Choose Card >"
      cmds = get_commands(@hand)
      card = nil
      loop do
        key = Display.getch
        Display.backslash
        if cmds.include?(key)
          card = @hand.get_card(key.to_idx)
          break
        else
          Display.warn "\"#{key}\": Command not found."
          Display.backline
        end
      end
      card
    end

    def choose_supply_card(opts = {})
      Display.clear
      Log.show(3)
      @@supply.display
      Display.notice "< Choose Supply >"
      cmds = get_commands(@@supply)
      idx = nil
      loop do
        key = Display.getch
        Display.backslash
        unless cmds.include?(key)
          Display.warn "\"#{key}\": Command not found."
          Display.backline
          next
        end
        idx = key.to_idx
        if opts[:max_cost] && @@supply.cost(idx) > opts[:max_cost]
          Display.warn "\"#{@@supply.get_card_name(idx)}\" Costs over. You choose card costing up to #{opts[:max_cost]} Coins."
          Display.backline
          next
        end
        return @@supply.get_card(idx) if supply_stock?(idx)
      end
    end

    def gain_to_discard(card)
      @@supply.remove(card, @discard)
      Log.add "#{@name} gain \"#{card.name}\"."
      card
    end

    def trash_from_hand(card)
      @hand.remove(card, @@trash)
      Log.add "#{@name} trashs \"#{card.name}\"."
      card
    end

    def receive_command
      Display.notice "< Press Command Key > "
      key = Display.getch
      Display.backslash
      key
    end

    def wait_until_press_enter
      Display.notice "< Press Enter Key >"
      loop do
        break if Display.getch == KEY_ENTER
        Display.backslash
      end
    end

    private

    def get_commands(target)
      ("a".."z").to_a.shift(target.size)
    end
  end
end
