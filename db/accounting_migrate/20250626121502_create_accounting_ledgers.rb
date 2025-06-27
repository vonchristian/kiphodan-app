class CreateAccountingLedgers < ActiveRecord::Migration[8.0]
  def change
    create_table :accounting_ledgers, id: :uuid do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.boolean :contra, null: false, default: false
      t.uuid :financial_institution_id

      t.timestamps
    end

    add_index :accounting_ledgers, :financial_institution_id
    add_index :accounting_ledgers, [ :financial_institution_id, :name ], unique: true
    add_index :accounting_ledgers, [ :financial_institution_id, :code ], unique: true
  end
end
