module PairGenerator
  def self.find_new_pairs(history)
    people = history.flatten.uniq
    possible_pairs = people.combination(2).to_a - history

    get_pairs(people, possible_pairs)
  end

  private
  def self.get_pairs(people, possible_pairs)
    # binding.pry
    return [] if people.length == 0
    return [people] if people.length == 1
    possible_pairs.each do |pair_candidate|
      safe_possible_pairs = possible_pairs.dup
      safe_people = people.dup - pair_candidate
      remaining_pairs = safe_possible_pairs.delete_if {|pair| pair.include?(pair_candidate[0]) || pair.include?(pair_candidate[1])}
      if safe_people.all? {|person| remaining_pairs.flatten.include?(person)}
        if other_pairs = get_pairs(safe_people, remaining_pairs)
          # binding.pry
          return other_pairs + [pair_candidate]
        end
      end
    end
    false
  end
end