$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "rdominion/deck"

module Rdominion
  describe "StandardDeck" do
    context "card empty" do
      let(:standard_deck) { StandardDeck.new }

      describe "#add" do
        context "with a object" do
          it "should be add a object" do
            obj = Object.new
            standard_deck.add(obj)
            expect(standard_deck.get_card(0)).to eq obj
          end
        end

        context "with 10 objects" do
          it "should be add 10 objects" do
            objs = Array.new(10, Object.new)
            standard_deck.add(objs)
            expect(standard_deck.size).to eq 10
          end
        end
      end
    end
  end
end
