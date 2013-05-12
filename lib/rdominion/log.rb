module Rdominion
  module Log
    @logs = []

    def self.add(text)
      @logs.push("#{text}")
      @logs.shift if @logs.size >= 100
    end

    def self.show(row = 40)
      text = @logs.last(row).join("\n")
      Display.add_info "[ Game Log ]"
      Display.add_text(text)
      Display.add_break
      Display.show
    end
  end
end
