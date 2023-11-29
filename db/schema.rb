# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2023_02_22_021301) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accountants", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "theme", default: "light"
    t.index ["email"], name: "index_accountants_on_email", unique: true
    t.index ["reset_password_token"], name: "index_accountants_on_reset_password_token", unique: true
  end

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

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "role"
    t.integer "status", default: 1
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "agent_id"
    t.string "theme", default: "light"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "bids", force: :cascade do |t|
    t.integer "homework_id"
    t.integer "tutor_id"
    t.integer "ammount"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "chats", force: :cascade do |t|
    t.integer "qna_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "conversation_id"
    t.integer "chattable_id"
    t.string "chattable_type"
    t.integer "admin_id"
    t.integer "manager_id"
    t.string "name"
  end

  create_table "contacts", force: :cascade do |t|
    t.string "full_name"
    t.string "email"
    t.string "phone_number"
    t.text "message"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "documents", force: :cascade do |t|
    t.integer "homework_id"
    t.integer "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "documentable_id"
    t.string "documentable_type"
  end

  create_table "homeworks", force: :cascade do |t|
    t.integer "user_id"
    t.integer "tutor_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "manager_id"
    t.integer "status", default: 0
    t.integer "order_type"
    t.integer "payment_status"
    t.integer "payment_type"
    t.datetime "deadline"
    t.text "details"
    t.integer "subject_id"
    t.integer "words"
    t.datetime "tutor_deadline"
    t.integer "price"
    t.integer "grade"
    t.integer "admin_id"
    t.string "name"
    t.string "subject"
    t.string "sub_type"
    t.string "sub_subject"
    t.boolean "priority", default: false
    t.boolean "tutor_skills", default: false
    t.boolean "tutor_samples", default: false
    t.boolean "view_bidders", default: false
    t.boolean "login_school", default: false
    t.datetime "received"
    t.integer "hours_late"
    t.text "notes"
    t.string "prof"
    t.integer "grade_get"
    t.integer "sub_tutor_id"
    t.integer "tutor_category"
    t.text "updates"
    t.datetime "payment_received"
    t.datetime "file_received"
    t.integer "tutor_price"
    t.integer "profit"
    t.datetime "internal_deadline"
    t.string "internal_subject"
    t.string "voucher"
    t.boolean "in_bank"
    t.boolean "soft_deleted", default: false
    t.datetime "deleted_at"
    t.integer "min_bid"
  end

  create_table "managers", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "status", default: 1
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "agent_id"
    t.string "theme", default: "light"
    t.index ["email"], name: "index_managers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_managers_on_reset_password_token", unique: true
  end

  create_table "messages", force: :cascade do |t|
    t.integer "chat_id"
    t.text "content"
    t.integer "sendable_id"
    t.string "sendable_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "prof_reviews", force: :cascade do |t|
    t.integer "professor_id"
    t.integer "user_id"
    t.integer "status", default: 1
    t.text "content"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "school_id"
    t.string "school"
    t.integer "easiness"
    t.integer "effectiveness"
    t.integer "life_changing"
    t.integer "light_workload"
    t.integer "leniency"
    t.integer "average"
    t.integer "a_able"
    t.integer "b_pls_able"
    t.integer "b_able"
    t.integer "c_able"
    t.integer "batch1_able"
    t.integer "batch2_able"
    t.integer "batch3_able"
    t.integer "batch4_able"
    t.string "subject"
    t.string "school_name"
    t.integer "additional_metric_grade"
  end

  create_table "professors", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.integer "school_id"
    t.integer "easiness"
    t.integer "effectiveness"
    t.integer "life_changing"
    t.integer "light_workload"
    t.integer "leniency"
    t.float "average"
    t.integer "a_able"
    t.integer "b_pls_able"
    t.integer "b_able"
    t.integer "c_able"
    t.integer "batch1_able"
    t.integer "batch2_able"
    t.integer "batch3_able"
    t.integer "batch4_able"
    t.integer "bad_comments"
    t.text "our_comments"
    t.integer "status"
    t.string "subject"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "email"
    t.integer "additional_metric_grade"
  end

  create_table "qna_types", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "qnas", force: :cascade do |t|
    t.integer "user_id"
    t.integer "tutor_id"
    t.text "question"
    t.string "subject"
    t.integer "status", default: 0
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "auth"
    t.integer "qna_type_id"
    t.integer "amount"
    t.datetime "date_paid"
    t.integer "payment_status"
  end

  create_table "quality_officers", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.boolean "active"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "theme", default: "light"
    t.index ["email"], name: "index_quality_officers_on_email", unique: true
    t.index ["reset_password_token"], name: "index_quality_officers_on_reset_password_token", unique: true
  end

  create_table "reviews", force: :cascade do |t|
    t.integer "user_id"
    t.integer "tutor_id"
    t.text "details"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "skills", force: :cascade do |t|
    t.integer "tutor_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tags", force: :cascade do |t|
    t.integer "document_id"
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "tutors", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.integer "status", default: 0
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "school"
    t.integer "category"
    t.string "identifier_string"
    t.string "theme", default: "light"
    t.index ["email"], name: "index_tutors_on_email", unique: true
    t.index ["reset_password_token"], name: "index_tutors_on_reset_password_token", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name"
    t.string "last_name"
    t.date "birthday"
    t.string "school"
    t.integer "status", default: 1
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "level"
    t.string "contact_id"
    t.string "identifier_string"
    t.string "theme", default: "light"
    t.string "course"
    t.integer "year"
    t.string "college"
    t.string "address"
    t.string "phone_number"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
end
