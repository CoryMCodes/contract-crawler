class CreateContractCrawlerCoreTables < ActiveRecord::Migration[8.0]
  def change
    create_table :sources do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.string :kind, null: false
      t.string :base_url
      t.boolean :active, null: false, default: true
      t.jsonb :settings, null: false, default: {}
      t.datetime :last_synced_at

      t.timestamps
    end
    add_index :sources, "lower(slug)", unique: true, name: "index_sources_on_lower_slug"

    create_table :buyers do |t|
      t.string :name, null: false
      t.string :state
      t.string :city
      t.string :source_identifier
      t.string :website_url

      t.timestamps
    end

    create_table :source_records do |t|
      t.references :source, null: false, foreign_key: true
      t.string :external_id, null: false
      t.string :fingerprint, null: false
      t.jsonb :raw_payload, null: false, default: {}
      t.text :raw_body
      t.datetime :fetched_at, null: false
      t.string :parser_version, null: false, default: "v1"
      t.string :status, null: false, default: "fetched"

      t.timestamps
    end
    add_index :source_records, %i[source_id fingerprint], unique: true
    add_index :source_records, %i[source_id external_id]

    create_table :opportunities do |t|
      t.references :source, null: false, foreign_key: true
      t.references :source_record, null: false, foreign_key: true
      t.references :buyer, null: false, foreign_key: true
      t.string :external_id, null: false
      t.string :title, null: false
      t.text :description
      t.string :buyer_name
      t.string :state
      t.string :city
      t.string :source_name
      t.string :source_url
      t.string :solicitation_number
      t.string :category
      t.datetime :due_date
      t.datetime :posted_at
      t.string :contract_type
      t.string :set_aside
      t.decimal :estimated_value_low, precision: 14, scale: 2
      t.decimal :estimated_value_high, precision: 14, scale: 2
      t.string :naics_codes, array: true, null: false, default: []
      t.string :status, null: false
      t.text :raw_text
      t.text :summary_ai
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end
    add_index :opportunities, %i[source_id external_id], unique: true
    add_index :opportunities, :state
    add_index :opportunities, :status
    add_index :opportunities, :due_date
    add_index :opportunities, :naics_codes, using: :gin

    create_table :attachments do |t|
      t.references :opportunity, null: false, foreign_key: true
      t.string :title, null: false
      t.string :file_url, null: false
      t.string :content_type
      t.jsonb :metadata, null: false, default: {}

      t.timestamps
    end

    create_table :awards do |t|
      t.references :opportunity, null: false, foreign_key: true
      t.string :vendor_name, null: false
      t.decimal :amount, precision: 14, scale: 2
      t.date :awarded_at
      t.string :award_number
      t.string :source_url

      t.timestamps
    end
  end
end
