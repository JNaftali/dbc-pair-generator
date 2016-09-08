require_relative '../cohort'

describe Cohort do
  let(:cohort) do
    people = [:margaret, :matt, :elisa, :shawn, :terrance, :josh, :kiren, :rachel]
    history = [[:margaret, :matt], [:elisa, :josh]]
    Cohort.new(people: people, history: history)
  end

  let(:short)  {Cohort.new(history: [[:jon, :melissa], [:josh, :shawn], [:jon, :josh], [:melissa, :shawn]])}
  let(:medium) {Cohort.new(history: [[:jon, :melissa], [:josh, :shawn], [:anders, :terrance], [:jon, :josh], [:melissa, :anders], [:shawn, :terrance]])}
  let(:long)   {Cohort.new(history: [[:jon, :melissa], [:josh, :shawn], [:anders, :terrance], [:ephraim, :kiren], [:jon, :amanda], [:anders, :shawn], [:josh, :terrance], [:melissa, :kiren], [:amanda, :neel], [:edwin, :jon], [:ephraim, :shawn], [:henri, :rachel], [:josh, :melissa], [:terrance, :kiren], [:amanda, :ephraim], [:anders, :rachel], [:daniel, :josh], [:neel, :terrance], [:moin, :melissa]])}
  let(:invalid) {Cohort.new(history: [[:jon, :melissa], [:jon, :josh]])}

  describe "#sort_rank" do
    it "gives a group a number based on the number of times the individuals have worked with each other" do
      expect(cohort.sort_rank(:josh, :elisa, :matt, :margaret)).to eq(2)
      expect(cohort.sort_rank(:josh, :elisa, :matt)).to eq(1)
      expect(cohort.sort_rank(:josh, :shawn, :matt, :margaret)).to eq(1)
    end

    it "returns zero if called with no group" do
      expect(cohort.sort_rank).to eq(0)
    end

    it "returns the number of groups that contain that person if only one person is given" do
      expect(cohort.sort_rank(:josh)).to eq(1)
      expect(cohort.sort_rank(:shawn)).to eq(0)
    end
  end

  describe "#initialize" do
    it "derives the people involved from the provided history" do
      expect(short.people).to eq([:jon, :josh, :melissa, :shawn])
      expect(medium.people).to eq([:anders, :jon, :josh, :melissa, :shawn, :terrance])
      expect(long.people).to eq([:amanda,  :anders,  :daniel,  :edwin,  :ephraim,  :henri,  :jon,  :josh,  :kiren,  :melissa,  :moin,  :neel,  :rachel,  :shawn, :terrance])
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

  describe "#next_groups" do
    describe "when working with pairs" do
      it "if there's only one person, return that person alone" do
        expect(Cohort.new(people: [:josh]).next_groups).to eq ([[:josh]])
      end

      it "doesn't repeat historical combinations if there are alternatives" do
        expect(short.next_groups.any?{|item| short.history.include?(item) }).to be(false)
      end
    end
  end
end
