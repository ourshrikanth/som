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

ActiveRecord::Schema.define(version: 20150122120349) do

  create_table "allocated_resources", force: true do |t|
    t.date     "from_date"
    t.date     "to_date"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "comments", force: true do |t|
    t.string   "comment"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "commentable_id"
    t.string   "commentable_type"
  end

  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "departments", force: true do |t|
    t.string   "name"
    t.string   "status",     limit: 8, default: "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "holidays", force: true do |t|
    t.string   "occassion"
    t.date     "holiday_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "planned_tasks", force: true do |t|
    t.text     "title"
    t.decimal  "work_hours",        precision: 5, scale: 2
    t.decimal  "billable_hours",    precision: 5, scale: 2
    t.integer  "planning_sheet_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "planned_tasks", ["planning_sheet_id"], name: "index_planned_tasks_on_planning_sheet_id", using: :btree

  create_table "planning_sheets", force: true do |t|
    t.string   "status",         limit: 9
    t.integer  "week_no"
    t.integer  "year"
    t.date     "from_date"
    t.date     "to_date"
    t.decimal  "total_hours",              precision: 5, scale: 2
    t.decimal  "planned_hours",            precision: 5, scale: 2
    t.decimal  "billable_hours",           precision: 5, scale: 2
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "planning_sheets", ["user_id"], name: "index_planning_sheets_on_user_id", using: :btree

  create_table "projects", force: true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "status",      limit: 8, default: "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  create_table "requested_resources", force: true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.decimal  "hours",               precision: 5, scale: 2
    t.integer  "resource_request_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "requested_resources", ["resource_request_id"], name: "index_requested_resources_on_resource_request_id", using: :btree
  add_index "requested_resources", ["user_id"], name: "index_requested_resources_on_user_id", using: :btree

  create_table "resource_requests", force: true do |t|
    t.text     "comments"
    t.integer  "user_id"
    t.string   "status",     limit: 9, default: "submitted"
    t.integer  "project_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resource_requests", ["project_id"], name: "index_resource_requests_on_project_id", using: :btree
  add_index "resource_requests", ["user_id"], name: "index_resource_requests_on_user_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.string   "status",     limit: 8, default: "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_users", force: true do |t|
    t.integer  "user_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "approver"
  end

  add_index "team_users", ["team_id"], name: "index_team_users_on_team_id", using: :btree
  add_index "team_users", ["user_id"], name: "index_team_users_on_user_id", using: :btree

  create_table "teams", force: true do |t|
    t.string   "name"
    t.string   "status",        limit: 8, default: "active"
    t.integer  "department_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "teams", ["department_id"], name: "index_teams_on_department_id", using: :btree

  create_table "technologies", force: true do |t|
    t.string   "name"
    t.string   "status",     limit: 8, default: "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_skills", force: true do |t|
    t.integer  "user_id"
    t.integer  "technology_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_skills", ["technology_id"], name: "index_user_skills_on_technology_id", using: :btree
  add_index "user_skills", ["user_id"], name: "index_user_skills_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "employee_id",                      default: "",       null: false
    t.string   "role_id",                          default: "",       null: false
    t.string   "email",                            default: "",       null: false
    t.string   "encrypted_password",               default: "",       null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                    default: 0,        null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status",                 limit: 8, default: "active"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
