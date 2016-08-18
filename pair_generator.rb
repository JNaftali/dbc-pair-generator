class PairGenerator
  def initialize(array)
    if array.any? {|el| el.is_a?(Array)}
      @history = array
    else
      @people = array
    end
    @history ||= []
    @people += @history.flatten.uniq
  end

  def find_new_pairs
    possible_pairs = people.combination(2).to_a - history

    get_pairs(people, possible_pairs)
  end

  private
  def permitted_pairs
    @people.permutation(2).to_a - history
  end

  def get_pairs(people, possible_pairs)
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

  def ==(other)
    self.people.sort == other.people.sort
  end
end

# past_pairs = [[:jon, :melissa], [:josh, :shawn], [:anders, :terrance], [:ephraim, :kiren], [:jon, :amanda], [:anders, :shawn], [:josh, :terrance], [:melissa, :kiren], [:amanda, :neel], [:edwin, :jon], [:ephraim, :shawn], [:henri, :rachel], [:josh, :melissa], [:terrance, :kiren], [:amanda, :ephraim], [:anders, :rachel], [:daniel, :josh], [:neel, :terrance], [:moin, :melissa]]

# p PairGenerator.find_new_pairs(past_pairs)
