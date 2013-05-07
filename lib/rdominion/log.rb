module Rdominion
  module Log
    @logs = []

    def self.add(text)
      @logs.push("#{text}")
      @logs.shift if @logs.size >= 100
    end

    def self.show(row = 40)
      text = @logs.last(row).join("\n")
      Display.addinfo "[ Game Log ]"
      Display.addstr(text)
      Display.break
      Display.show
    end
  end
end
