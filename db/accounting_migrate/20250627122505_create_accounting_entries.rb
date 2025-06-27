class CreateAccountingEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :accounting_entries, id: :uuid do |t|
      t.datetime :posted_at
      t.string :reference_number
      t.string :description
      t.uuid :financial_institution_id
      t.timestamps
    end

    add_index :accounting_entries, :posted_at
    add_index :accounting_entries, :created_at
    add_index :accounting_entries, :financial_institution_id
    add_index :accounting_entries, :reference_number
    add_index :accounting_entries, :description
  end
end
