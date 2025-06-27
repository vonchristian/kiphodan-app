class CreateAccountingEntryLineItems < ActiveRecord::Migration[8.0]
  def change
    create_table :accounting_entry_line_items, id: :uuid do |t|
      t.belongs_to :entry, null: false, foreign_key: { to_table: :accounting_entries }, type: :uuid
      t.belongs_to :account, null: false, foreign_key: { to_table: :accounting_accounts }, type: :uuid
      t.integer :amount_cents, limit: 8, null: false, default: 0
      t.string :amount_currency, null: false, default: "PHP"
      t.uuid :financial_institution_id

      t.timestamps
    end

    add_index :accounting_entry_line_items, [ :account_id, :entry_id ]
    add_index :accounting_entry_line_items, [ :entry_id, :account_id ]
    add_index :accounting_entry_line_items, :financial_institution_id
  end
end
