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

ActiveRecord::Schema.define(:version => 20170801130858) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.datetime "expires"
    t.string   "nickname"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "drain_claims", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
    t.integer  "gid"
    t.boolean  "shoveled"
    t.string   "notes"
  end

  add_index "drain_claims", ["gid"], :name => "index_drain_claims_on_gid"
  add_index "drain_claims", ["user_id"], :name => "index_drain_claims_on_user_id"

  create_table "mitaro_dar", :id => false, :force => true do |t|
    t.integer "gid",                                        :null => false
    t.string  "the_geom",     :limit => 0
    t.string  "full_id",      :limit => 254
    t.string  "waterway",     :limit => 254
    t.string  "covered",      :limit => 254
    t.string  "depth",        :limit => 254
    t.string  "width",        :limit => 254
    t.string  "blockage",     :limit => 254
    t.string  "tunnel",       :limit => 254
    t.string  "diameter",     :limit => 254
    t.string  "ditch",        :limit => 254
    t.string  "drain",        :limit => 254
    t.string  "name",         :limit => 254
    t.string  "bridge",       :limit => 254
    t.string  "height",       :limit => 254
    t.string  "surface",      :limit => 254
    t.string  "smoothness",   :limit => 254
    t.string  "oneway",       :limit => 254
    t.float   "lat"
    t.float   "lng"
    t.boolean "cleared"
    t.boolean "need_help"
    t.string  "address"
    t.string  "zipcode"
    t.integer "claims_count",                :default => 0
  end

  add_index "mitaro_dar", ["cleared"], :name => "index_mitaro_dar_on_cleared"

  create_table "spatial_ref_sys", :id => false, :force => true do |t|
    t.integer "srid",                      :null => false
    t.string  "auth_name", :limit => 256
    t.integer "auth_srid"
    t.string  "srtext",    :limit => 2048
    t.string  "proj4text", :limit => 2048
  end

  create_table "streets", :force => true do |t|
    t.string   "street_name"
    t.string   "ward_name"
    t.string   "municipal_name"
    t.string   "city_name"
    t.datetime "created_at",                                     :null => false
    t.datetime "updated_at",                                     :null => false
    t.decimal  "lat",            :precision => 16, :scale => 14
    t.decimal  "lng",            :precision => 16, :scale => 14
  end

  create_table "users", :force => true do |t|
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.string   "first_name",                                :null => false
    t.string   "last_name",                                 :null => false
    t.string   "organization"
    t.string   "email",                  :default => "",    :null => false
    t.string   "sms_number",             :default => "",    :null => false
    t.boolean  "admin",                  :default => false
    t.integer  "claims_count",           :default => 0
    t.integer  "role",                   :default => 1
    t.integer  "max_claims"
    t.integer  "street_id"
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["sms_number"], :name => "index_users_on_sms_number", :unique => true

end
