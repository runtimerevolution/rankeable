# Rankeable
[![Build Status](https://travis-ci.org/runtimerevolution/rankeable.png?branch=master)](https://travis-ci.org/runtimerevolution/rankeable)

#### Rankeable is a Ranking System for your Rails Application.

Rankeable Gem wraps all the model content of your rankings and let you define only
the rules your ranking needs.

Rankeable is useful when:
 - you want to extract business rules from models
 - you have sorting rules and you want apply those rules to different models

## Getting Started

### Main Features:

- High flexibility for different scenarios (make strategies of sorting applied to different models)
- Easy Integration with DelayJob, SideKiq and Resque

## Installation

```ruby
gem 'rankeable'
```
Afterwards copy and run migrations:
```sh
rails generate rankeable:install
bundle exec rake db:migrate
```
After Installation Rankeable generates a RankingsRules Class
inside of ranking_concerns folder (you can change the location of RankingRules Class.
The only constraint is the existence of RankingRules in your application nothing more).

## Integrate Rankeable with your Business Logic

For example, using the context of a Game that have many players and referees.

```ruby
Class Game < ActiveRecord::Base
	has_rankings
	has_many :players
	has_many :referees

	# ...
end

Class Player < ActiveRecord::Base
	is_rankeable

	# ...
end

Class Referee < ActiveRecord::Base
	is_rankeable
	# ...
end
```
#### How Ranking works

Ranking has some important components:

- rankeable: which is the object with rankings assigned (in our example is Game). Give us to context of ranking, e.g the current game.
- ranked_type: The model we want to rank
- ranked_call: The strategy chosen to rank the ranked_type

## Create New Ranking

1. Add a ranking rule that takes the number of goals by player:

```ruby
# creating ranking with rule "number_of_goals"
@game.rankings.create(:name => "goals_by_player",
	:ranked_type => "Player", :ranked_call => "number_of_goals")

# in file app/ranking_concerns/ranking_rules.rb

# Rule Number of Goals
def number_of_goals(ranking, *args)
	ranking.rankeable.players.order("goals DESC").map do |player|
		OpenStructure.new(:value => player.goals,
			:ranked_object => player, label => "#{player.name} - #{player.number}")
	end
end
```

2. Add a ranking rule that takes the number of faults marked in the game:

```ruby
# creating ranking with rule "number_of_faults"
@game.rankings.create(:name => "faults_by_refeere",
	:ranked_type => "Refeere", :ranked_call => "number_of_faults")

# in file app/ranking_concerns/ranking_rules.rb

# Rule Number of Faults
def number_of_faults(ranking, *args)
	ranking.rankeable.refeeres.map { |refeere|
		total_faults = refeere.red_cards + refeere.yellow_cards
		OpenStructure.new(:value => total_faults,
			:ranked_object => player, :label => refeere.name)
	}.sort {|a,b| b.value <=> a.value }
end
```
## Ranking Rules Protocol

Every Ranking Rule must return a collection with objects that respond to:

- label => a label describing the object ranked
- ranked_object => The target object of the ranking
- value => The value calculated on Ranking rule

## See Rankeable Working

```ruby
# find our number_of_goals strategy for this game
rank_scores = @game.rankings.find_by_name("goals_by_player")

#calculate our rankings
rank_scores.calculate

# show the results
puts @values_of_score
=> [#<RankingValue position=1, value=2, ranked_object=#<Player id: 13, name: "Chuck Norris", goals: 2, created_at: "2013-01-31 14:48:54", updated_at: "2013-01-31 14:48:54">>,
#<RankingValue position=2, value=1, ranked_object=#<User id: 8, name: "Bob", goals: 1, created_at: "2013-01-31 14:48:54", updated_at: "2013-01-31 14:48:54">>]

# calculate the number_of_faults strategy
number_of_cards_rank = @game.rankings.find_by_name("faults_by_refeere")

# calculate our rankings
number_of_cards_rank.calculate

# check the result of our ranking strategy
@cards_values = number_of_cards_rank.values

# show the results
puts @cards_values
=> [#<RankingValue position=1, value=3, ranked_object=#<Refeere id: 13, name: "Rijjecak", yellow_cards: 2, red_cards=1, created_at: "2013-01-31 14:48:54", updated_at: "2013-01-31 14:48:54">>,
#<RankingValue position=2, value=1, ranked_object=#<Refeere id: 8, name: "Jackson", yellow_cards=1, red_cards=0, created_at: "2013-01-31 14:48:54", updated_at: "2013-01-31 14:48:54">>]

```
## Help your migrations

#### Rankeable help us with migrations.
To create a model with rankings you can use `has_rankings` option, but if you want
a model who is the target of your ranking use `is_rankeable` option instead.
This will create the model (if one doesn't exist) and configure it with default Rankeable Modules.

```sh
# creating Game Model
rails g has_rankings game name:string
# creating Player Model
rails g is_rankeable player name:string number:integer goals:integer
# creating Referee Model
rails g is_rankeable referee name:string number_of_faults:integer yellow_cards:integer red_cards:integer
```
This is the scafold generated by the Rankeable migration helper.
Next, you must run the migrate command in order to the changes
take the effect.


## Integration with Delay Job and others

When we have more complicated rules we dont want to make the calculations during the request time
so you can integrate Rankeable with delay_job, sidekiq or resque.
Just an example using Delay Job:

```ruby
rank_scores_for_refeeres = @game.rankings.where(:ranked_call => "number_of_goals",
	:ranked_type => "Refeere").first
rank_scores_for_refeeres.delay.calculate
```

This project rocks and uses MIT-LICENSE.