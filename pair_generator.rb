require 'forwardable'

class PairGenerator
  attr_reader :people, :history
  def initialize(args={})
    @history = args.fetch(:history, []).map(&:to_a)
    @people = args.fetch(:people, []) | @history.flatten
    @history.map! {|pair| Pair.new(pair)}
  end

  def valid?
    # return false if self.permitted_pairs.length == 0 && self.people.length > 0
    self.people.all? { |person| self.permitted_pairs.any?{ |pair| pair.include?(person) } }
  end

  def get_next_pairs
    return [self.people[0]] if self.people.length == 1
    return [self.permitted_pairs[0]] if self.people.length == 2 && self.permitted_pairs.length == 1
    self.permitted_pairs.each do |next_pair|
      # binding.pry
      next_history = self.history.reject { |past_pair| past_pair.overlap?(next_pair) }
      next_people = self.people - next_pair.people
      next_group = PairGenerator.new(history: next_history, people: next_people)
      next unless next_group.valid?
      pairs = next_group.get_next_pairs
      next unless pairs
      return [next_pair] + next_group.get_next_pairs
    end
    false
  end

  def possible_pairs
    @people.combination(2).to_a.map{|p| Pair.new(p)}
  end

  def permitted_pairs
    self.possible_pairs.reject { |pair| @history.any?{ |past_pair| pair == past_pair}}
  end
end

class Pair
  attr_reader :people
  include Enumerable
  include Comparable
  extend Forwardable

  def_delegators :@people, :each, :include?

  def initialize(*array)
    @people = array.flatten.sort
  end

  def <=>(other)
    self.people <=> other.people
  end

  def overlap?(other_pair)
    @people.any? {|person| other_pair.include?(person)}
  end

  def to_a
    @people
  end
end

# test = PairGenerator.new(history: [[:jon, :melissa], [:josh, :shawn], [:anders, :terrance], [:ephraim, :kiren], [:jon, :amanda], [:anders, :shawn], [:josh, :terrance], [:melissa, :kiren], [:amanda, :neel], [:edwin, :jon], [:ephraim, :shawn], [:henri, :rachel], [:josh, :melissa], [:terrance, :kiren], [:amanda, :ephraim], [:anders, :rachel], [:daniel, :josh], [:neel, :terrance], [:moin, :melissa]])
# past_pairs = [[:jon, :melissa], [:josh, :shawn], [:anders, :terrance], [:ephraim, :kiren], [:jon, :amanda], [:anders, :shawn], [:josh, :terrance], [:melissa, :kiren], [:amanda, :neel], [:edwin, :jon], [:ephraim, :shawn], [:henri, :rachel], [:josh, :melissa], [:terrance, :kiren], [:amanda, :ephraim], [:anders, :rachel], [:daniel, :josh], [:neel, :terrance], [:moin, :melissa]]

# p PairGenerator.find_new_pairs(past_pairs)
