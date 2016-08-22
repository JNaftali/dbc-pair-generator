require_relative '../pair_generator'

describe Pair do
  let(:pair1) {Pair.new(:foo,:bar)}
  let(:pair2) {Pair.new(:foo,:buzz)}
  let(:pair3) {Pair.new(:fizz,:buzz)}
  
  describe "#initialize" do
    it "correctly interprets both multiple arguments and arrays" do
      expect(pair1).to eq(Pair.new([:foo,:bar]))
    end
  end

  describe "#==" do
    it "returns true for pairs initialized in different orders" do
      expect(pair1).to eq(Pair.new(:bar,:foo))
    end
  end

  describe "#overlap?" do
    it "returns true if the pairs are the same" do
      expect(pair1.overlap?(pair1)).to be true
    end
    it "returns true if they share any elements" do
      expect(pair1.overlap?(pair2)).to be true
    end
    it "returns false if they don't share any elements" do
      expect(pair1.overlap?(pair3)).to be false
    end
  end

  describe "#to_a" do
    it "returns the people array" do
      expect(pair1.to_a).to eq(pair1.people)
    end
  end
end
