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

ActiveRecord::Schema[8.0].define(version: 2026_04_03_000100) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "attachments", force: :cascade do |t|
    t.bigint "opportunity_id", null: false
    t.string "title", null: false
    t.string "file_url", null: false
    t.string "content_type"
    t.jsonb "metadata", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["opportunity_id"], name: "index_attachments_on_opportunity_id"
  end

  create_table "awards", force: :cascade do |t|
    t.bigint "opportunity_id", null: false
    t.string "vendor_name", null: false
    t.decimal "amount", precision: 14, scale: 2
    t.date "awarded_at"
    t.string "award_number"
    t.string "source_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["opportunity_id"], name: "index_awards_on_opportunity_id"
  end

  create_table "buyers", force: :cascade do |t|
    t.string "name", null: false
    t.string "state"
    t.string "city"
    t.string "source_identifier"
    t.string "website_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "opportunities", force: :cascade do |t|
    t.bigint "source_id", null: false
    t.bigint "source_record_id", null: false
    t.bigint "buyer_id", null: false
    t.string "external_id", null: false
    t.string "title", null: false
    t.text "description"
    t.string "buyer_name"
    t.string "state"
    t.string "city"
    t.string "source_name"
    t.string "source_url"
    t.string "solicitation_number"
    t.string "category"
    t.datetime "due_date"
    t.datetime "posted_at"
    t.string "contract_type"
    t.string "set_aside"
    t.decimal "estimated_value_low", precision: 14, scale: 2
    t.decimal "estimated_value_high", precision: 14, scale: 2
    t.string "naics_codes", default: [], null: false, array: true
    t.string "status", null: false
    t.text "raw_text"
    t.text "summary_ai"
    t.jsonb "metadata", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_opportunities_on_buyer_id"
    t.index ["due_date"], name: "index_opportunities_on_due_date"
    t.index ["naics_codes"], name: "index_opportunities_on_naics_codes", using: :gin
    t.index ["source_id", "external_id"], name: "index_opportunities_on_source_id_and_external_id", unique: true
    t.index ["source_id"], name: "index_opportunities_on_source_id"
    t.index ["source_record_id"], name: "index_opportunities_on_source_record_id"
    t.index ["state"], name: "index_opportunities_on_state"
    t.index ["status"], name: "index_opportunities_on_status"
  end

  create_table "source_records", force: :cascade do |t|
    t.bigint "source_id", null: false
    t.string "external_id", null: false
    t.string "fingerprint", null: false
    t.jsonb "raw_payload", default: {}, null: false
    t.text "raw_body"
    t.datetime "fetched_at", null: false
    t.string "parser_version", default: "v1", null: false
    t.string "status", default: "fetched", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["source_id", "external_id"], name: "index_source_records_on_source_id_and_external_id"
    t.index ["source_id", "fingerprint"], name: "index_source_records_on_source_id_and_fingerprint", unique: true
    t.index ["source_id"], name: "index_source_records_on_source_id"
  end

  create_table "sources", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.string "kind", null: false
    t.string "base_url"
    t.boolean "active", default: true, null: false
    t.jsonb "settings", default: {}, null: false
    t.datetime "last_synced_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "lower((slug)::text)", name: "index_sources_on_lower_slug", unique: true
  end

  add_foreign_key "attachments", "opportunities"
  add_foreign_key "awards", "opportunities"
  add_foreign_key "opportunities", "buyers"
  add_foreign_key "opportunities", "source_records"
  add_foreign_key "opportunities", "sources"
  add_foreign_key "source_records", "sources"
end
