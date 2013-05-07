require 'curses'

module Rdominion
  module Display
    Curses.start_color
    Curses.init_pair(1, Curses::COLOR_YELLOW, 0)
    Curses.init_pair(2, Curses::COLOR_CYAN, 0)
    Curses.init_pair(3, Curses::COLOR_RED, 0)
    Curses.init_pair(4, Curses::COLOR_GREEN, 0)
    Curses.init_pair(5, Curses::COLOR_MAGENTA, 0)
    @display = Curses::Window.new(40, 80, 0, 0)

    def self.addstr(text)
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
        self.break
      end
    end

    def self.addinfo(text)
      self.addstr("<!color:cyan><!bold>#{text}<!/bold><!/color>")
    end

    def self.warn(text)
      self.addstr("<!color:red>#{text}<!/color>")
      self.show
    end

    def self.notice(text)
      self.addstr("<!color:green>#{text}<!/color>")
      self.show
    end

    def self.clear
      @display.clear
    end

    def self.show
      @display.refresh
    end

    def self.getch
      @display.getch
    end

    def self.break
      @display.addstr("\n")
    end

    def self.backslash
      @display.setpos(@display.cury, 0)
    end

    def self.backline(num = 1)
      @display.setpos(@display.cury - num, 0)
    end

    def self.close
      @display.close
    end
  end
end
