require 'curses'

module Rdominion
  class Display
    Curses.start_color
    Curses.init_pair(1, Curses::COLOR_YELLOW, 0)
    Curses.init_pair(2, Curses::COLOR_CYAN, 0)
    Curses.init_pair(3, Curses::COLOR_RED, 0)
    Curses.init_pair(4, Curses::COLOR_GREEN, 0)
    Curses.init_pair(5, Curses::COLOR_MAGENTA, 0)
    @display = Curses::Window.new(40, 80, 0, 0)

    class << self
      def add_text(text)
        text.split("\n", -1).each do |line|
          words = line.split(/(<!\/?[a-z:]*>)/)
          words.delete("")
          if words.empty?
            self.break
            next
          end
          words.each do |word|
            case word
              when "<!color:yellow>" then @display.attron(Curses.color_pair(1))
              when "<!color:cyan>" then @display.attron(Curses.color_pair(2))
              when "<!color:red>" then @display.attron(Curses.color_pair(3))
              when "<!color:green>" then @display.attron(Curses.color_pair(4))
              when "<!color:magenta>" then @display.attron(Curses.color_pair(5))
              when "<!/color>" then @display.attroff(Curses::A_COLOR)
              when "<!bold>" then @display.attron(Curses::A_BOLD)
              when "<!/bold>" then @display.attroff(Curses::A_BOLD)
              else @display.addstr(word)
            end
          end
          add_break
        end
      end

      def add_info(text)
        add_text("<!color:cyan><!bold>#{text}<!/bold><!/color>")
      end

      def add_break
        @display.addstr("\n")
      end

      def warn(text)
        add_text("<!color:red>#{text}<!/color>")
        show
      end

      def notice(text)
        add_text("<!color:green>#{text}<!/color>")
        show
      end

      def clear
        @display.clear
      end

      def show
        @display.refresh
      end

      def getch
        key = @display.getch
        backslash
        key
      end


      def backslash
        @display.setpos(@display.cury, 0)
      end

      def backline(num = 1)
        @display.setpos(@display.cury - num, 0)
      end

      def close
        @display.close
      end
    end
  end
end
