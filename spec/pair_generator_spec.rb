require_relative '../pair_generator_2'

describe PairGenerator do
  let(:short)  {PairGenerator.new(history: [[:jon, :melissa], [:josh, :shawn]])}
  let(:medium) {PairGenerator.new(history: [[:jon, :melissa], [:josh, :shawn], [:anders, :terrance], [:jon, :josh], [:melissa, :anders], [:shawn, :terrance]])}
  let(:long)   {PairGenerator.new(history: [[:jon, :melissa], [:josh, :shawn], [:anders, :terrance], [:ephraim, :kiren], [:jon, :amanda], [:anders, :shawn], [:josh, :terrance], [:melissa, :kiren], [:amanda, :neel], [:edwin, :jon], [:ephraim, :shawn], [:henri, :rachel], [:josh, :melissa], [:terrance, :kiren], [:amanda, :ephraim], [:anders, :rachel], [:daniel, :josh], [:neel, :terrance], [:moin, :melissa]])}

  describe "#initialize" do
    it "derives the people involved from the provided history" do
      expect(short.people.sort).to eq([:jon, :josh, :melissa, :shawn])
      expect(medium.people.sort).to eq([:anders, :jon, :josh, :melissa, :shawn, :terrance])
      expect(long.people.sort).to eq([:amanda,  :anders,  :daniel,  :edwin,  :ephraim,  :henri,  :jon,  :josh,  :kiren,  :melissa,  :moin,  :neel,  :rachel,  :shawn, :terrance])
    end

    it "stores past pairs as Pair objects" do
      expect(long.history).to all(be_an(Pair))
    end
  end

  describe "#valid?"
end
