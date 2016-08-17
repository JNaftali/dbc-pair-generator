module PairGenerator
  def find_new_pairs(history)
    people = history.flatten.unique
    possible_pairs = people.combination(2).to_a - history

    get_pairs(people, possible_pairs)
  end

  private
  def get_pairs(people, possible_pairs)
    possible_pairs.each do |pair_candidate|
      safe_possible_pairs = possible_pairs.dup
      safe_people = people.dup - pair_candidate
      remaining_pairs = safe_possible_pairs.delete_if {|pair| pair.include?(pair_candidate[0]) || pair.include?(pair_candidate[1])}
      return [pair_candidate] + get_pairs(safe_people, remaining_pairs) if people.all? {|person| remaining_pairs.flatten.include?(person)}
    end
  end
end