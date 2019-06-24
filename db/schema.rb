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

ActiveRecord::Schema.define(version: 2019_06_06_163711) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "sitio"
    t.string "barangay"
    t.string "municipality"
    t.string "province"
    t.string "full_details"
    t.boolean "default", default: false
    t.string "addressable_type"
    t.uuid "addressable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
  end

  create_table "business_hours", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.time "am_starts_at"
    t.time "am_ends_at"
    t.time "pm_starts_at"
    t.time "pm_ends_at"
    t.integer "employee_role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "configurations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "display_duration"
    t.datetime "deployed_at"
    t.datetime "subscribed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "dtr_signatory"
  end

  create_table "contacts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "number"
    t.boolean "default", default: false
    t.string "contactable_type"
    t.uuid "contactable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["contactable_type", "contactable_id"], name: "index_contacts_on_contactable_type_and_contactable_id"
  end

  create_table "departments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "emergency_contacts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "relationship"
    t.uuid "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "full_name"
    t.index ["employee_id"], name: "index_emergency_contacts_on_employee_id"
  end

  create_table "employees", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.string "full_name"
    t.string "alternate_email"
    t.string "designation"
    t.date "birthdate"
    t.integer "marital_status"
    t.string "spouse_name"
    t.integer "role"
    t.string "default_key"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.uuid "school_id"
    t.uuid "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.uuid "schedule_id"
    t.index ["department_id"], name: "index_employees_on_department_id"
    t.index ["email"], name: "index_employees_on_email", unique: true
    t.index ["reset_password_token"], name: "index_employees_on_reset_password_token", unique: true
    t.index ["schedule_id"], name: "index_employees_on_schedule_id"
    t.index ["school_id"], name: "index_employees_on_school_id"
  end

  create_table "holidays", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "holiday_type"
    t.datetime "dated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "id_cards", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "id_number"
    t.integer "rfid_uid"
    t.boolean "default", default: false
    t.uuid "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_id_cards_on_employee_id"
  end

  create_table "license_and_insurances", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "pagibig_number"
    t.string "sss_number"
    t.string "phil_health_number"
    t.string "prc_license_number"
    t.string "tin_number"
    t.uuid "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_license_and_insurances_on_employee_id"
  end

  create_table "overtime_configs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "minimum_overtime", default: 0
    t.integer "applies_to"
    t.time "starts_at"
    t.time "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "position_titles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.boolean "default", default: false
    t.integer "placement"
    t.uuid "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_position_titles_on_employee_id"
  end

  create_table "schedules", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.integer "shift_type"
    t.time "starts_at"
    t.time "ends_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "schools", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "time_logs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "logged_at"
    t.integer "status"
    t.uuid "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_time_logs_on_employee_id"
  end

  create_table "time_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "logged_at"
    t.integer "remark"
    t.integer "meridian"
    t.uuid "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_time_records_on_employee_id"
  end

  create_table "worked_times", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.date "date"
    t.datetime "in_at"
    t.datetime "out_at"
    t.integer "duration", default: 0
    t.integer "overtime", default: 0
    t.uuid "employee_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_worked_times_on_employee_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "emergency_contacts", "employees"
  add_foreign_key "employees", "departments"
  add_foreign_key "employees", "schedules"
  add_foreign_key "employees", "schools"
  add_foreign_key "id_cards", "employees"
  add_foreign_key "license_and_insurances", "employees"
  add_foreign_key "position_titles", "employees"
  add_foreign_key "time_logs", "employees"
  add_foreign_key "time_records", "employees"
  add_foreign_key "worked_times", "employees"
end
