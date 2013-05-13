module Rdominion
  module Command
    def receive_command
      Display.notice "< Press Command Key > "
      Display.getch
    end

    def wait_until_press_enter
      Display.notice "< Press Enter Key >"
      loop { break if Display.getch == KEY_ENTER }
    end

    def ask_quit_game
      Display.backline
      Display.notice "< NOTICE > Are you sure you want to quit? (Y/N)"
      Display.add_break
      Display.backline
      exit if receive_yes_or_no
    end

    def receive_yes_or_no
      loop do
        key = Display.getch.to_s.upcase
        case key
          when "Y" then return true
          when "N" then return false
        end
      end
    end

    def command_not_found(cmd)
      Display.caution "\"#{cmd}\": Command not found."
      Display.backline
    end
  end
end
