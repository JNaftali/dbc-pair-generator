require_relative 'pair_generator'

roster = [:jon, :melissa, :josh, :shawn, :anders, :terrance, :ephraim, :kiren, :amanda, :neel, :edwin, :henri, :rachel, :daniel, :moin]
pair_groups = []

history = {people: roster, history: [[:jon, :josh]]}

while new_group = PairGenerator.new(history).next_set_of_pairs
  pair_groups << new_group
  history = {history: pair_groups.flatten(1)}
end
pair_groups.each do |pair_group|
  puts pair_group.reduce('| ') { |str, pair| str + pair.join(", ") + " | " }
end
