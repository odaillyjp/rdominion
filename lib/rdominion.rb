require "rdominion/extension"
require "rdominion/display"
require "rdominion/log"
require "rdominion/card"
require "rdominion/deck"
require "rdominion/supply"
require "rdominion/player"
require "rdominion/command"

module Rdominion
  KEY_ENTER = 10
  KEY_ESC = 27

  class Game
    include Command

    def initialize
      @player_1 = Player.new("Player")
      @player_2 = Player.new("Computer")
      @phase = ""
      @turn = 1
    end

    def run
      begin
        Log.add "--- Game Setup ---"
        loop do
          [@player_1, @player_2].each do |player|
            Log.add "--- #{player.name}: #{@turn} turn ---"
            phase_action(player)
            phase_buy(player)
            phase_clean_up(player)
          end
          @turn += 1
        end
      ensure
        Log.add "--- Quit Game ---"
        Display.close
      end
    end

    private

    def phase_action(player)
      @phase = "Action"
      show_phase_info(player)
      play_cmds = player.hand_commands
      while player.action > 0 do
        cmd = player.receive_command
        case cmd
          when KEY_ENTER then break
          when KEY_ESC
            ask_quit_game
            show_phase_info(player)
          when "S"
            show_supply(player)
            show_phase_info(player)
          when "L"
            show_game_log(player)
            show_phase_info(player)
          when *play_cmds then player_action(player, cmd)
          else
            command_not_found(cmd)
            Display.backline
        end
      end
    end

    def phase_buy(player)
      @phase = "Buy"
      player.play_tresure_all
      show_phase_info(player)
      play_cmds = player.supply_commands
      while player.buy > 0 do
        cmd = player.receive_command
        case cmd
          when KEY_ENTER then break
          when KEY_ESC
            ask_quit_game
            show_phase_info(player)
          when "I"
            show_hand(player)
            show_phase_info(player)
          when "L"
            show_game_log(player)
            show_phase_info(player)
          when *play_cmds then player_buy(player, cmd)
          else
            command_not_found(cmd)
            Display.backline
        end
      end
    end

    def phase_clean_up(player)
      player.clean_up
    end

    def show_phase_info(player)
      Display.clear
      player.show_status
      Log.show(3)
      case @phase
        when "Action" then player.show_hand
        when "Buy" then player.show_supply
      end
      show_command
      Display.show
    end

    def show_supply(player)
      Display.clear
      player.show_supply
      player.wait_until_press_enter
    end

    def show_hand(player)
      Display.clear
      player.show_hand
      player.wait_until_press_enter
    end

    def show_game_log(player)
      Display.clear
      Log.show(30)
      player.wait_until_press_enter
    end

    def player_action(player, cmd)
      if player.play_action(cmd.to_idx)
        show_phase_info(player)
      else
        Display.backline
      end
    end

    def player_buy(player, cmd)
      if player.buy_supply(cmd.to_idx)
        show_phase_info(player)
      else
        Display.backline
      end
    end

    def show_command
      cmds = [
        ["S", "Show supplies"],
        ["I", "Show player hand card"],
        ["L", "Show game log"],
        ["ENTER", "Done phase" ],
        ["ESC", "Quit Game"]
      ]
      case @phase
        when "Action" then cmds.delete_at(1)
        when "Buy" then cmds.delete_at(0)
      end
      Display.add_info "[ Command ]"
      cmds.each { |cmd| Display.add_text("(#{cmd[0]}) #{cmd[1]}") }
      Display.add_break
    end
  end
end
