class PairGenerator
  attr_reader :people, :history
  def initialize(array)
    if array.any? {|el| el.is_a?(Array)}
      @history = array
    else
      @people = array
    end
    @history ||= []
    @people ||= []
    @people += @history.flatten.uniq
    @history.map! {|pair| Pair.new(pair)}
  end

  def possible_pairs
    @people.combination(2).to_a.map{|p| Pair.new(p)}
  end

  def permitted_pairs
    self.possible_pairs.reject { |pair| @history.any?{ |past_pair| pair == past_pair}}
  end

  def get_pairs
    return [] if people.length == 0
    return [people] if people.length == 1
    return false unless people.all? {|person| possible_pairs.flatten.include?(person)}
  end
end

class Pair
  attr_reader :people
  include Comparable

  def initialize(array)
    @people = array
  end

  def <=>(other)
    self.people.sort <=> other.people.sort
  end

  def include?(thing)
    self.people.include?(thing)
  end
end

# past_pairs = [[:jon, :melissa], [:josh, :shawn], [:anders, :terrance], [:ephraim, :kiren], [:jon, :amanda], [:anders, :shawn], [:josh, :terrance], [:melissa, :kiren], [:amanda, :neel], [:edwin, :jon], [:ephraim, :shawn], [:henri, :rachel], [:josh, :melissa], [:terrance, :kiren], [:amanda, :ephraim], [:anders, :rachel], [:daniel, :josh], [:neel, :terrance], [:moin, :melissa]]

# p PairGenerator.find_new_pairs(past_pairs)
