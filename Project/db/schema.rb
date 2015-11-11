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

ActiveRecord::Schema.define(:version => 20140830120412) do

  create_table "booking_stats", :force => true do |t|
    t.integer  "user_id"
    t.integer  "bookingCount"
    t.date     "expire"
    t.integer  "semesterExpCount"
    t.date     "semesterStart"
    t.integer  "totalExpCount"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "bookings", :force => true do |t|
    t.integer  "student_id"
    t.integer  "experiment_id"
    t.integer  "user_id"
    t.date     "date"
    t.boolean  "double_booked", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "calendars", :force => true do |t|
    t.date     "date"
    t.integer  "experiment_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "changed_exp_days", :force => true do |t|
    t.integer  "experiment_id"
    t.date     "date"
    t.string   "time"
    t.boolean  "is_available"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_points", :force => true do |t|
    t.integer  "cp"
    t.integer  "experiment"
    t.integer  "report"
    t.integer  "poster"
    t.integer  "talk"
    t.integer  "assignment"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "experiment_availabilities", :force => true do |t|
    t.integer  "experiment_id"
    t.date     "date"
    t.string   "time"
    t.boolean  "is_available"
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "experiments", :force => true do |t|
    t.string   "exp_num"
    t.string   "name"
    t.string   "extended_name"
    t.integer  "num_sessions",  :default => 2,     :null => false
    t.integer  "weight",        :default => 1,     :null => false
    t.boolean  "available",     :default => true
    t.boolean  "double_booked", :default => false
    t.text     "comments"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lab_days", :force => true do |t|
    t.date     "date"
    t.string   "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "marks", :force => true do |t|
    t.integer  "experiment_id"
    t.integer  "student_id"
    t.integer  "user_id"
    t.string   "mark_type"
    t.decimal  "mark",          :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "password_resets", :force => true do |t|
    t.integer  "user_id"
    t.string   "token"
    t.datetime "timestamp"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "permissions", :force => true do |t|
    t.string   "class_name"
    t.boolean  "admin",           :default => true
    t.boolean  "tutor",           :default => false
    t.boolean  "student",         :default => false
    t.string   "menu_controller"
    t.string   "menu_action"
    t.string   "display_text"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  create_table "reports", :force => true do |t|
    t.integer  "user_id"
    t.string   "report_file_name"
    t.string   "report_content_type"
    t.integer  "report_file_size"
    t.datetime "report_updated_at"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "settings", :force => true do |t|
    t.string   "name"
    t.string   "string"
    t.integer  "integer"
    t.decimal  "decimal",    :precision => 10, :scale => 0
    t.date     "date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "student_semesters", :force => true do |t|
    t.integer  "student_id"
    t.integer  "year"
    t.integer  "semester"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "students", :force => true do |t|
    t.string   "sid"
    t.string   "first_name"
    t.string   "last_name"
    t.integer  "cp"
    t.text     "comments"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "students", ["email"], :name => "index_students_on_email", :unique => true

  create_table "tutors", :force => true do |t|
    t.string   "username"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "phone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "comments"
  end

  create_table "users", :force => true do |t|
    t.string   "username",   :null => false
    t.string   "password",   :null => false
    t.string   "role",       :null => false
    t.integer  "details_id", :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

end
