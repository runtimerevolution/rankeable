require 'helper'

# create or open class Ranking Rules in order
# to test a ranking creating

class RankingRules
  def score_by_points(ranking_object, *args)
    users = eval(ranking_object.ranked_type).all
    users.map { |user|
      OpenStruct.new({:value => user.points, :subject => user })
    }.sort { |a,b| b.value <=> a.value }
  end

  def score_by_name_size(ranking_object, *args)
    users = eval(ranking_object.ranked_type).all
    users.map { |user|
      OpenStruct.new({:value => user.name.length, :subject => user })
    }.sort { |a,b| b.value <=> a.value }
  end
end

# create a ranking assigned with a ranking function
# to collect metrics from User model
def create_rank_with_ranking_function(rank_func, klass)
  rank = FactoryGirl.create(:ranking, :ranked_type_call => rank_func, :ranked_type => klass)
  # Calculate all the ranking values
  rank.calculate
  rank
end

# test two collections comparing id from each other
def test_failure_collection(ranking_values, users_list)
  ranking_values.each_with_index do |rank, index|
    expect(users_list[index].id).to_not eq rank.ranked_object.id
  end
end
# test two collections comparing id from each other
def test_success_collection(ranking_values, users_list)
  ranking_values.each_with_index do |rank, index|
    expect(users_list[index].id).to eq rank.ranked_object.id
  end
end

describe "Rankeable and Ranking Behaviour" do

  it "should return success if the collection of Rank Values is ordered by pontuation" do
    # prepare a collection of users with different points
    10.times do
      number = (rand * 10).to_i
      FactoryGirl.create(:user, :points => number)
    end

    # prepare our excpectation
    users_ordered_by_points = User.order("points DESC")

    # create a ranking with a ranked target User and dealing with score of points
    rank = create_rank_with_ranking_function("score_by_points", "User")

    # Assert Collection by success
    test_success_collection(rank.values, users_ordered_by_points)
    # Assert Collection by failure
    test_failure_collection(rank.values, User.order("points ASC"))
  end

  it "should return success if the collection of Rank Values is ordered by name size" do
    # prepare a collection of users with different name lengths
    10.times do
      repetition_number = (rand * 10).to_i
      FactoryGirl.create(:user, :name => ("a" * repetition_number))
    end

    # prepare our excpectation
    users_ordered_by_name_size =  User.all.sort { |a,b| b.name.length <=> a.name.length }

    # create a ranking with a ranked target User and dealing the size of name string
    rank = create_rank_with_ranking_function("score_by_name_size", "User")

    # Assert Collection by success
    test_success_collection(rank.values, users_ordered_by_name_size)
    # Assert Collection by failure
    test_failure_collection(rank.values, users_ordered_by_name_size.reverse)
  end

end