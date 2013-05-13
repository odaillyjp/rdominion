$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require "rdominion/card"

module Rdominion
  describe "Card" do
    let(:card) { Card.new }

    describe "#name" do
      it { expect(card.name).to eq "Card" }
    end

    describe "#tresure?" do
      it { expect(card.tresure?).to be_false }
    end

    describe "#action?" do
      it { expect(card.action?).to be_false }
    end

    describe "#reaction?" do
      it { expect(card.reaction?).to be_false }
    end
  end

  describe "Tresure" do
    let(:tresure) { Tresure.new }

    describe ".color" do
      it { expect(Tresure.color).to eq "yellow" }
    end

    describe "#tresure?" do
      it { expect(tresure.tresure?).to be_true }
    end
  end

  describe "Copper" do
   it { expect(Copper).not_to be_nil }

    context "created instance." do
      let(:copper) { Copper.new }

      describe "#name" do
        it { expect(copper.name).to eq "Copper" }
      end

      describe "#cost" do
        it { expect(copper.cost).to eq 0 }
      end

      describe "#coin" do
        it { expect(copper.coin).to eq 1 }
      end
    end
  end

  describe "Silver" do
    it { expect(Silver).not_to be_nil }

    context "Created instance" do
      let(:silver) { Silver.new }

      describe "#name" do
        it { expect(silver.name).to eq "Silver" }
      end

      describe "#cost" do
        it { expect(silver.cost).to eq 3 }
      end

      describe "#coin" do
        it { expect(silver.coin).to eq 2 }
      end
    end
  end

  describe "Gold" do
    it { expect(Gold).not_to be_nil }

    context "Created instance" do
      let(:gold) { Gold.new }

      describe "#name" do
        it { expect(gold.name).to eq "Gold" }
      end

      describe "#cost" do
        it { expect(gold.cost).to eq 6 }
      end

      describe "#coin" do
        it { expect(gold.coin).to eq 3 }
      end
    end
  end

  describe "Victory" do
    let(:victory) { Victory.new }

    describe ".color" do
      it { expect(Victory.color).to eq "green" }
    end
  end

  describe "Estate" do
    it { expect(Estate).not_to be_nil }

    context "created instance" do
      let(:estate) { Estate.new }

      describe "#name" do
        it { expect(estate.name).to eq "Estate" }
      end

      describe "#cost" do
        it { expect(estate.cost).to eq 2}
      end

      describe "#victory" do
        it { expect(estate.victory).to eq 1}
      end
    end
  end

  describe "Duchy" do
    it { expect(Duchy).not_to be_nil }

    context "created instance" do
      let(:duchy) { Duchy.new }

      describe "#name" do
        it { expect(duchy.name).to eq "Duchy" }
      end

      describe "#cost" do
        it { expect(duchy.cost).to eq 5}
      end

      describe "#victory" do
        it { expect(duchy.victory).to eq 3}
      end
    end
  end

  describe "Province" do
    it { expect(Province).not_to be_nil }

    context "created instance" do
      let(:province) { Province.new }

      describe "#name" do
        it { expect(province.name).to eq "Province" }
      end

      describe "#cost" do
        it { expect(province.cost).to eq 8}
      end

      describe "#victory" do
        it { expect(province.victory).to eq 6}
      end
    end
  end
end
