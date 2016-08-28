class PairGenerator
  attr_accessor :people, :history
  def initialize(args={})
    @history = args.fetch(:history, []).map(&:sort)
    @people = args.fetch(:people, []) | @history.flatten
  end

  def next_set_of_pairs(add_to_history = false)
    if self.people.length == 1
      return false if self.history.include?(self.people)
      return [self.people]
    end
    return [self.people.sort] if self.people.length == 2
    self.permitted_pairs.each do |next_pair|
      @next_pair = next_pair
      candidate = PairGenerator.new(history: self.next_history, people: self.next_people)
      next unless candidate.valid? && (rest_of_pairs = candidate.next_set_of_pairs)
      result = [@next_pair] + rest_of_pairs
      if add_to_history
        self.history += result
      end
      return result
    end
    false
  end

  def next_history
    self.history.reject{ |pair| pair.any?{ |person| @next_pair.include?(person)}}
  end

  def next_people
    self.people - @next_pair
  end

  def valid?
    return false if self.people.empty?
    return true if self.people.length == 1
    self.people.all? { |person| self.permitted_pairs.flatten.include?(person) }
  end

  def people_by_flexibility
    self.people.sort_by { |person| self.permitted_pairs.count { |pair| pair.include? (person) } }
  end

  def possible_pairs
    self.people.combination(2).to_a.map(&:sort)
  end

  def permitted_pairs
    self.possible_pairs - self.history
  end
end
