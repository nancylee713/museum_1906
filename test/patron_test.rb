require 'minitest/autorun'
require 'minitest/pride'
require './lib/patron'

class PatronTest < Minitest::Test

  def setup
    @bob = Patron.new("Bob", 20)
  end

  def test_it_exists
    assert_instance_of Patron, @bob
  end

  def test_attributes
    assert_equal "Bob", @bob.name
    assert_equal 20, @bob.spending_money
  end

  def test_interests_start_out_as_empty
    assert @bob.interests.empty?
  end

  def test_it_can_add_interest(new_interest)
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("Gems and Minerals")

    assert_equal ["Dead Sea Scrolls", "Gems and Minerals"], @bob.interests
  end
end
