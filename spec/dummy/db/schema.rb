# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130130111155) do

  create_table "ranking_values", :force => true do |t|
    t.integer  "ranking_id"
    t.integer  "position"
    t.integer  "value"
    t.string   "label"
    t.string   "ranked_object_type"
    t.integer  "ranked_object_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "rankings", :force => true do |t|
    t.string   "name"
    t.integer  "site_id"
    t.string   "rankeable_type"
    t.integer  "rankeable_id"
    t.string   "ranked_type"
    t.string   "ranked_type_call"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "sites", :force => true do |t|
    t.string   "url"
    t.integer  "context"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.integer  "points"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
