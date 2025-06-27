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

ActiveRecord::Schema[8.0].define(version: 2025_06_27_134120) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pgcrypto"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "accounting_account_type", ["asset", "equity", "liability", "revenue", "expense"]
  create_enum "accounting_entry_line_item_type", ["debit", "credit"]

  create_table "accounting_accounts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.boolean "contra", default: false, null: false
    t.uuid "financial_institution_id"
    t.uuid "ledger_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "account_type", null: false, enum_type: "accounting_account_type"
    t.index ["account_type"], name: "index_accounting_accounts_on_account_type"
    t.index ["financial_institution_id", "code"], name: "index_accounting_accounts_on_financial_institution_id_and_code", unique: true
    t.index ["financial_institution_id", "name"], name: "index_accounting_accounts_on_financial_institution_id_and_name", unique: true
    t.index ["financial_institution_id"], name: "index_accounting_accounts_on_financial_institution_id"
    t.index ["ledger_id"], name: "index_accounting_accounts_on_ledger_id"
  end

  create_table "accounting_entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "posted_at"
    t.string "reference_number"
    t.string "description"
    t.uuid "financial_institution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_accounting_entries_on_created_at"
    t.index ["description"], name: "index_accounting_entries_on_description"
    t.index ["financial_institution_id"], name: "index_accounting_entries_on_financial_institution_id"
    t.index ["posted_at"], name: "index_accounting_entries_on_posted_at"
    t.index ["reference_number"], name: "index_accounting_entries_on_reference_number"
  end

  create_table "accounting_entry_line_items", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "entry_id", null: false
    t.uuid "account_id", null: false
    t.bigint "amount_cents", default: 0, null: false
    t.string "amount_currency", default: "PHP", null: false
    t.uuid "financial_institution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "line_item_type", null: false, enum_type: "accounting_entry_line_item_type"
    t.index ["account_id", "entry_id"], name: "index_accounting_entry_line_items_on_account_id_and_entry_id"
    t.index ["account_id"], name: "index_accounting_entry_line_items_on_account_id"
    t.index ["entry_id", "account_id"], name: "index_accounting_entry_line_items_on_entry_id_and_account_id"
    t.index ["entry_id"], name: "index_accounting_entry_line_items_on_entry_id"
    t.index ["financial_institution_id"], name: "index_accounting_entry_line_items_on_financial_institution_id"
    t.index ["line_item_type"], name: "index_accounting_entry_line_items_on_line_item_type"
  end

  create_table "accounting_ledgers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.boolean "contra", default: false, null: false
    t.uuid "financial_institution_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.enum "account_type", null: false, enum_type: "accounting_account_type"
    t.index ["account_type"], name: "index_accounting_ledgers_on_account_type"
    t.index ["financial_institution_id", "code"], name: "index_accounting_ledgers_on_financial_institution_id_and_code", unique: true
    t.index ["financial_institution_id", "name"], name: "index_accounting_ledgers_on_financial_institution_id_and_name", unique: true
    t.index ["financial_institution_id"], name: "index_accounting_ledgers_on_financial_institution_id"
  end

  add_foreign_key "accounting_accounts", "accounting_ledgers", column: "ledger_id"
  add_foreign_key "accounting_entry_line_items", "accounting_accounts", column: "account_id"
  add_foreign_key "accounting_entry_line_items", "accounting_entries", column: "entry_id"
end
