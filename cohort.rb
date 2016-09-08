class Cohort
  attr_accessor :history, :people, :size
  def initialize(args={})
    @history = args.fetch(:history) {[]}.map(&:sort)
    @people = args.fetch(:people) || @history.flatten
    @people.sort!
    @size = args.fetch(:size, 2).to_i
  end

  def next_groups(save=true)
    return [self.people] if self.people.length <=
     self.size
    groups_enum.each do |group|
      new_cohort = Cohort.new(
        history: self.history,
        people: self.people - group,
        size: self.size
      )
      result = [group] + new_cohort.next_groups if new_cohort.valid?
      self.history += result if save
      return result
    end
  end

  def valid?
    return true if self.people.length < self.size
    (self.people.combination(self.size).to_a - self.history).flatten.uniq.sort & self.people == self.people
  end

  def sort_rank(*group)
    return 0 if group.length == 0
    return self.history.count {|past_group| past_group.include?(group[0])} if group.length == 1

    group.sort.combination(2).reduce(0) { |sum, pair| sum + self.history.count {|past_group| past_group & pair == pair} }
  end

  def groups_enum
    Enumerator.new do |y|
      people  = self.people.dup
      history = self.history.map(&:dup)

      until people.empty?
        next_group = []
        until next_group.length == self.size || people.empty?
          people = people.sort {|a,b| self.sort_rank(*next_group, a) <=> self.sort_rank(*next_group, b)}
          next_group << people.find {|person| !next_group.include?(person)}
        end
        history << next_group
        y << next_group
      end
    end
  end
end
