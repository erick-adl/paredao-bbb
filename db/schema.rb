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

ActiveRecord::Schema.define(version: 20141201174140) do

  create_table "admins", force: true do |t|
    t.string   "email",              default: "", null: false
    t.string   "encrypted_password", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true, using: :btree

  create_table "contestants", force: true do |t|
    t.string "name"
    t.string "avatar"
  end

  create_table "votes", force: true do |t|
    t.integer "contestant_id"
    t.string  "time"
  end

  add_index "votes", ["contestant_id"], name: "index_votes_on_contestant_id", using: :btree
  add_index "votes", ["time"], name: "index_votes_on_time", using: :btree

end
