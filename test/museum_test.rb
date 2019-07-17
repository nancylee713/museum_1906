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
    @bob = Patron.new("Bob", 20)
    @sally = Patron.new("Sally", 20)
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

end
