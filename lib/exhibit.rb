class Exhibit

  attr_reader :name, :cost

  def initialize(name, cost=0)
    @name = name
    @cost = cost
  end
end
