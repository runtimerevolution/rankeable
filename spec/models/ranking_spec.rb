# create or open class Ranking Rules in order
# to test a ranking creating
class RankingRules
  def valid_method
    # nothing to do here
  end
end

describe "Ranking" do
  it "should create a valid Ranking" do
    expect {
      FactoryGirl.create(:ranking)
    }.to change(Ranking, :count).by(1)
  end

  it "should not create a Ranking without a valid ranked_function" do
    expect {
      FactoryGirl.create(:ranking, :ranked_type_call => "invalid_method")
    }.to raise_error(ActiveRecord::RecordInvalid)

    expect {
      FactoryGirl.create(:ranking, :ranked_type_call => "valid_method")
    }.to change(Ranking, :count).by(1)
  end

  it "should not create a Ranking without all the mandatory fields" do
    expect {
      FactoryGirl.create(:ranking, :rankeable => nil)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end
end