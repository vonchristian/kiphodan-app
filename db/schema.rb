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

ActiveRecord::Schema[8.0].define(version: 2025_06_26_123440) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "accounting_account_type", ["asset", "equity", "liability", "revenue", "expense"]

  create_table "ledgers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.boolean "contra", default: false, null: false
    t.uuid "financial_institution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "account_type", null: false, enum_type: "accounting_account_type"
    t.index ["account_type"], name: "index_ledgers_on_account_type"
    t.index ["financial_institution_id", "code"], name: "index_ledgers_on_financial_institution_id_and_code", unique: true
    t.index ["financial_institution_id", "name"], name: "index_ledgers_on_financial_institution_id_and_name", unique: true
    t.index ["financial_institution_id"], name: "index_ledgers_on_financial_institution_id"
  end
end
