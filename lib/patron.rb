class Patron

  attr_reader :name, :interests
  attr_accessor :spending_money

  def initialize(name, spending_money=20)
    @name = name
    @spending_money = spending_money
    @interests = []
  end

  def add_interest(new_interest)
    @interests << new_interest
  end
end
