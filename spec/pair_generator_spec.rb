require_relative '../pair_generator'

describe PairGenerator do
  let(:short)  {PairGenerator.new(history: [[:jon, :melissa], [:josh, :shawn], [:jon, :josh], [:melissa, :shawn]])}
  let(:medium) {PairGenerator.new(history: [[:jon, :melissa], [:josh, :shawn], [:anders, :terrance], [:jon, :josh], [:melissa, :anders], [:shawn, :terrance]])}
  let(:long)   {PairGenerator.new(history: [[:jon, :melissa], [:josh, :shawn], [:anders, :terrance], [:ephraim, :kiren], [:jon, :amanda], [:anders, :shawn], [:josh, :terrance], [:melissa, :kiren], [:amanda, :neel], [:edwin, :jon], [:ephraim, :shawn], [:henri, :rachel], [:josh, :melissa], [:terrance, :kiren], [:amanda, :ephraim], [:anders, :rachel], [:daniel, :josh], [:neel, :terrance], [:moin, :melissa]])}
  let(:invalid) {PairGenerator.new(history: [[:jon, :melissa], [:jon, :josh]])}

  describe "#initialize" do
    it "derives the people involved from the provided history" do
      expect(short.people.sort).to eq([:jon, :josh, :melissa, :shawn])
      expect(medium.people.sort).to eq([:anders, :jon, :josh, :melissa, :shawn, :terrance])
      expect(long.people.sort).to eq([:amanda,  :anders,  :daniel,  :edwin,  :ephraim,  :henri,  :jon,  :josh,  :kiren,  :melissa,  :moin,  :neel,  :rachel,  :shawn, :terrance])
    end
  end

  describe "#valid?" do
    it "returns false when there's no possible solution" do
      expect(invalid.valid?).to be false
    end
    it "returns true when there is a solution" do
      expect(long.valid?).to be true
    end
  end

  describe "#permitted_pairs" do
    it "never intersects with pairs from the history" do
      expect(short.permitted_pairs & short.history).to eq([])
      expect(medium.permitted_pairs & medium.history).to eq([])
      expect(long.permitted_pairs & long.history).to eq([])
    end
  end

  describe "#next_set_of_pairs" do
    it "if there's only one person, return that person alone" do
      expect(PairGenerator.new(people: [:josh]).next_set_of_pairs).to eq ([[:josh]])
    end
    it "can find the only solution when there is only one" do
      expect(short.next_set_of_pairs.sort).to eq([[:jon, :shawn], [:josh, :melissa]])
    end
  end
end
