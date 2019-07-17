require 'minitest/autorun'
require 'minitest/pride'
require './lib/museum'
require './lib/patron'
require './lib/exhibit'
require 'pry'

class MuseumTest < Minitest::Test

  def setup
    @dmns = Museum.new("Denver Museum of Nature and Science")
    @gems_and_minerals = Exhibit.new("Gems and Minerals", 0)
    @dead_sea_scrolls = Exhibit.new("Dead Sea Scrolls", 10)
    @imax = Exhibit.new("IMAX", 15)
    @bob = Patron.new("Bob", 10)
    @sally = Patron.new("Sally", 20)
    @tj = Patron.new("TJ", 7)
    @morgan = Patron.new("Morgan", 15)
  end

  def test_it_exists
    assert_instance_of Museum, @dmns
  end

  def test_it_has_a_name
    assert_equal "Denver Museum of Nature and Science", @dmns.name
  end

  def test_exhibits_start_out_as_empty_array
    assert @dmns.exhibits.empty?
  end

  def test_it_can_add_exhibits
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    assert_equal [@gems_and_minerals, @dead_sea_scrolls, @imax], @dmns.exhibits
  end

  def test_it_has_no_patrons_initially
    assert @dmns.patrons.empty?
  end

  def test_it_can_admit_patron
    @dmns.admit(@bob)
    @dmns.admit(@sally)

    assert_equal [@bob, @sally], @dmns.patrons
  end

  def test_it_can_recommend_exhibits
    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @bob.add_interest("Gems and Minerals")
    @bob.add_interest("Dead Sea Scrolls")
    @sally.add_interest("IMAX")

    assert_equal [@gems_and_minerals, @dead_sea_scrolls], @dmns.recommend_exhibits(@bob)
    refute @dmns.recommend_exhibits(@bob).include? @imax

    assert_equal [@imax], @dmns.recommend_exhibits(@sally)
    refute @dmns.recommend_exhibits(@sally).include? @gems_and_minerals
  end

  def test_it_can_list_patrons_by_exhibit_interest
    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("Gems and Minerals")
    @sally.add_interest("Dead Sea Scrolls")

    @dmns.add_exhibit(@gems_and_minerals)
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)

    @dmns.admit(@bob)
    @dmns.admit(@sally)

    expected = {
      @gems_and_minerals => [@bob],
      @dead_sea_scrolls => [@bob, @sally],
      @imax => []
    }

    assert_equal expected, @dmns.patrons_by_exhibit_interest
  end

  def test_patron_can_only_attend_exhibit_by_budget
    @dmns.add_exhibit(@dead_sea_scrolls)
    @dmns.add_exhibit(@imax)
    @dmns.add_exhibit(@gems_and_minerals)


    @tj.add_interest("IMAX")
    @tj.add_interest("Dead Sea Scrolls")
    @dmns.admit(@tj)

    assert_equal ({}), @dmns.patrons_of_exhibits
    assert_equal 7, @tj.spending_money

    @bob.add_interest("Dead Sea Scrolls")
    @bob.add_interest("IMAX")
    @dmns.admit(@bob)

    assert_equal 0, @bob.spending_money

    @sally.add_interest("IMAX")
    @sally.add_interest("Dead Sea Scrolls")
    @dmns.admit(@sally)

    assert_equal 5, @sally.spending_money

    @morgan.add_interest("Gems and Minerals")
    @morgan.add_interest("Dead Sea Scrolls")
    @dmns.admit(@morgan)

    assert_equal 5, @morgan.spending_money

    expected = {
      @dead_sea_scrolls => [@bob, @morgan],
      @imax => [@sally],
      @gems_and_minerals => [@morgan]
    }

    assert_equal expected, @dmns.patrons_of_exhibits
    assert_equal 35, @dmns.revenue
  end

end
