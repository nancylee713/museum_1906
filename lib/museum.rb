class Museum

  attr_reader :name, :exhibits, :patrons, :revenue

  def initialize(name)
    @name = name
    @exhibits = []
    @patrons = []
    @revenue = 0
  end

  def add_exhibit(new_exhibit)
    @exhibits << new_exhibit
  end

  def recommend_exhibits(patron)
    @exhibits.select { |exhibit| patron.interests.include? exhibit.name }
  end

  def admit(new_patron)
    @patrons << new_patron
  end

  def patrons_by_exhibit_interest
    results = Hash.new {|exhibit, patron| exhibit[patron]=[]}

    @exhibits.each do |exhibit|
      @patrons.each do |patron|
        if patron.interests.include? exhibit.name
          results[exhibit] << patron
        else
          results[exhibit]
        end
      end
    end
    results
  end


  def patrons_of_exhibits
    results = Hash.new {|exhibit, patron| exhibit[patron]=[]}

    @exhibits.each do |exhibit|
      @patrons.each do |patron|
        if patron.interests.include? exhibit.name && patron.spending_money > exhibit.cost
            results[exhibit] << patron
            @revenue += exhibit.cost
            patron.spending_money -= exhibit.cost
        end
      end
    end
    results
  end

end
