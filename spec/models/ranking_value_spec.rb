describe "RankingValue" do

  it "should create a valid Ranking Value" do
    expect {
      FactoryGirl.create(:ranking_value)
    }.to change(RankingValue, :count).by(1)
  end

  it "should not create a Ranking Value with a position already taken" do
    ranking = FactoryGirl.create(:ranking)
    value   = FactoryGirl.create(:ranking_value, :ranking => ranking)
    expect {
      FactoryGirl.create(:ranking_value, :ranking => ranking, :position => value.position)
    }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it "should not create a Ranking Value without all the mandatory fields" do
    [:ranking, :position, :value, :ranked_object].each do |field|
      expect {
        FactoryGirl.create(:ranking_value, field => nil)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  it "should return true if Ranking Values scoped by Ranking are returned from query" do
    rank_a = FactoryGirl.create(:ranking_value).ranking

    5.times { FactoryGirl.create(:ranking_value, :ranking => rank_a) }

    # All the records created are from ranking rank_a
    expect(RankingValue.for_ranking(rank_a)).to eq RankingValue.where(:ranking_id => rank_a.id)

    5.times { FactoryGirl.create(:ranking_value) }
    # Now some of the records doesn't belongs to rank_a
    expect(RankingValue.for_ranking(rank_a)).to_not eq RankingValue.scoped
  end
end