module PairParser
  def self.load_file(path)
    file = File.new(path)
    people = []
    until (next_person = file.gets) == "\n"
      people << next_person.chomp.to_sym
    end
    history = []
    while next_group = file.gets
      history << next_group.chomp.split(/, ?/).map(&:to_sym)
    end
    file.close
    {people: people, history: history}
  end

  def self.save_file(path, pairgen)
    File.open(path, "w") do |f|
      pairgen.people.each { |person| f << person << "\n" }
      f << "\n"
      pairgen.history.each { |group| f << group.map(&:to_s).join(", ") << "\n" }
    end
  end
end
