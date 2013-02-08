class Rankeable::InstallGenerator < Rails::Generators::Base #:nodoc:
  require 'rails/generators/migration'

  source_root File.expand_path("../templates", __FILE__)

  def copy_rankeable_gem_migrations
  	migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
  	unless migration_already_exists?
    	copy_file "create_rankings.rb", "db/migrate/#{migration_number}_create_rankings.rb"
    end
  end

  def add_ranking_rules_to_project
  	destination_path = "app/rankings/rankings_rules.rb"
  	if Dir.glob(destination_path).empty?
  		copy_file "ranking_rules.rb", destination_path
  	end
  end

  private

  def migration_already_exists?
  	 Dir.glob("#{File.join(destination_root, File.join("db", "migrate"))}/[0-9]*_*.rb").grep(/\d+_create_rankings.rb$/).first
  end

end