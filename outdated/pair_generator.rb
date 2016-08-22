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


  end

  def people_by_flexibility
    self.people.sort_by { |person| self.permitted_pairs.count { |pair| pair.include? (person) } }
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
  extend Forwardable

  def_delegators :@people, :include?, :to_a

  def initialize(*array)
    @people = array.flatten.sort
  end

  def ==(other)
    self.people == other.people
  end

  def overlap?(other_pair)
    @people.any? {|person| other_pair.include?(person)}
  end
end

# test = PairGenerator.new(history: [[:jon, :melissa], [:josh, :shawn], [:anders, :terrance], [:ephraim, :kiren], [:jon, :amanda], [:anders, :shawn], [:josh, :terrance], [:melissa, :kiren], [:amanda, :neel], [:edwin, :jon], [:ephraim, :shawn], [:henri, :rachel], [:josh, :melissa], [:terrance, :kiren], [:amanda, :ephraim], [:anders, :rachel], [:daniel, :josh], [:neel, :terrance], [:moin, :melissa]])
# past_pairs = [[:jon, :melissa], [:josh, :shawn], [:anders, :terrance], [:ephraim, :kiren], [:jon, :amanda], [:anders, :shawn], [:josh, :terrance], [:melissa, :kiren], [:amanda, :neel], [:edwin, :jon], [:ephraim, :shawn], [:henri, :rachel], [:josh, :melissa], [:terrance, :kiren], [:amanda, :ephraim], [:anders, :rachel], [:daniel, :josh], [:neel, :terrance], [:moin, :melissa]]

# p PairGenerator.find_new_pairs(past_pairs)


# [:jon, :melissa], [:josh, :shawn]
