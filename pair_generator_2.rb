class PairGenerator
  attr_reader :people, :history
  def initialize(args={})
    @history = args.fetch(:history, []).map(&:to_a)
    @people = args.fetch(:people, []) | @history.flatten
  end



  def valid?
    return true if self.people.length == 1
    self.people.all? { |person| self.permitted_pairs.flatten.include?(person) }
  end

  def people_by_flexibility
    self.people.sort_by { |person| self.permitted_pairs.count { |pair| pair.include? (person) } }
  end

  def possible_pairs
    self.people.combination(2).to_a
  end

  def permitted_pairs
    self.possible_pairs - self.history
  end
end
