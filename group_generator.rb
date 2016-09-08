module GroupGen
  def self.get_groups(cohort)
    Enumerator.new do |y|
      people  = cohort.people
      history = cohort.history.map { |thing| thing.class == Array ? thing.dup : thing}

      until people.empty?
        next_group = []
        until next_group.length == cohort.size || people.empty?
          people = people.sort {|a,b| cohort.sort_rank(*next_group, a) <=> cohort.sort_rank(*next_group, b)}
          next_group << people.find {|person| !next_group.include?(person)}
        end
        history << next_group
        y << next_group
      end
    end
  end
end
