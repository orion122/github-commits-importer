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

ActiveRecord::Schema.define(version: 2018_12_23_144445) do

  create_table "author_emails", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_author_emails_on_email", unique: true
  end

  create_table "author_emails_repos", force: :cascade do |t|
    t.integer "author_email_id"
    t.integer "repo_id"
    t.index ["author_email_id", "repo_id"], name: "index_author_emails_repos_on_author_email_id_and_repo_id", unique: true
  end

  create_table "commits", force: :cascade do |t|
    t.string "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "author_emails_repo_id"
    t.index ["author_emails_repo_id"], name: "index_commits_on_author_emails_repo_id"
  end

  create_table "owners", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_owners_on_name", unique: true
  end

  create_table "repos", force: :cascade do |t|
    t.string "name"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id"], name: "index_repos_on_owner_id"
  end

end
