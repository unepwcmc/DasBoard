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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140305153240) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "objective_id"
    t.string   "name"
    t.datetime "date"
  end

  create_table "metrics", force: true do |t|
    t.string "name"
    t.json   "data", default: []
  end

  create_table "objectives", force: true do |t|
    t.string  "name"
    t.integer "metric_id"
    t.integer "project_id"
    t.float   "threshold",  default: 0.0
  end

  add_index "objectives", ["metric_id"], name: "index_objectives_on_metric_id", using: :btree
  add_index "objectives", ["project_id"], name: "index_objectives_on_project_id", using: :btree

  create_table "projects", force: true do |t|
    t.string "name"
  end

end
