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

ActiveRecord::Schema.define(:version => 20120207161942) do

  create_table "links", :force => true do |t|
    t.integer  "fromnode"
    t.integer  "tonode"
    t.string   "polyline"
    t.string   "fromlatitude"
    t.string   "fromlongitude"
    t.string   "tolatitude"
    t.string   "tolongitude"
    t.boolean  "gmaps"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "nodes", :force => true do |t|
    t.float    "latitude"
    t.float    "longitude"
    t.boolean  "gmaps"
    t.string   "name"
    t.string   "street"
    t.string   "number"
    t.string   "city"
    t.string   "country"
    t.float    "demand"
    t.boolean  "depot"
    t.integer  "project_id"
    t.string   "polyline"
    t.integer  "tour_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "nodes", ["project_id"], :name => "index_nodes_on_project_id"
  add_index "nodes", ["tour_id"], :name => "index_nodes_on_tour_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.boolean  "distance_accuracy"
    t.boolean  "duration_accuracy"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["user_id"], :name => "index_projects_on_user_id"

  create_table "tours", :force => true do |t|
    t.string   "servicetime"
    t.string   "maxduration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

  create_table "vehicles", :force => true do |t|
    t.string   "VehicleName"
    t.string   "Type"
    t.float    "Capacity"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vehicles", ["project_id"], :name => "index_vehicles_on_project_id"

end
