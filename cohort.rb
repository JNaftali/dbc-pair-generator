class Cohort
  attr_accessor :history, :people, :size
  def initialize(args={})
    @history = args.fetch(:history) {[]}.map(&:sort)
    @people = args.fetch(:people) || @history.flatten
    @people.sort!
    @size = args.fetch(:size, 2)
  end

  def next_groups(save=true)
    return [self.people] if self.people.length <=
     self.size
    GroupGen.get_groups(self).each do |group|
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
end
