require_relative '../cohort'
require 'pry'

describe Cohort do
  let(:cohort) do
    people = [:margaret, :matt, :elisa, :shawn, :terrance, :josh, :kiren, :rachel]
    history = [[:margaret, :matt], [:elisa, :josh]]
    Cohort.new(people: people, history: history)
  end
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
end
