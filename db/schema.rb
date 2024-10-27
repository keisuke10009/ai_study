# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_10_26_040209) do
  create_table "comments", charset: "utf8mb3", force: :cascade do |t|
    t.text "comment", null: false
    t.bigint "user_id", null: false
    t.bigint "learning_outcome_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["learning_outcome_id"], name: "index_comments_on_learning_outcome_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "documents", charset: "utf8mb3", force: :cascade do |t|
    t.string "title", null: false
    t.text "document", null: false
    t.text "vocabulary", null: false
    t.text "summary_ai", null: false
    t.text "reflection_essay_ai", null: false
    t.integer "level_id", null: false
    t.integer "category_id", null: false
  end

  create_table "learning_outcomes", charset: "utf8mb3", force: :cascade do |t|
    t.integer "sum_rel_id", null: false
    t.text "text", null: false
    t.integer "score", null: false
    t.text "assessment", null: false
    t.bigint "user_id", null: false
    t.bigint "document_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_learning_outcomes_on_document_id"
    t.index ["user_id"], name: "index_learning_outcomes_on_user_id"
  end

  create_table "users", charset: "utf8mb3", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "nickname", null: false
    t.integer "points"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "comments", "learning_outcomes"
  add_foreign_key "comments", "users"
  add_foreign_key "learning_outcomes", "documents"
  add_foreign_key "learning_outcomes", "users"
end
