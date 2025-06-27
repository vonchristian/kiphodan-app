class CreateAccounts < ActiveRecord::Migration[8.0]
  def change
    create_table :accounting_accounts, id: :uuid do |t|
      t.string :name, null: false
      t.string :code, null: false
      t.boolean :contra, null: false, default: false
      t.uuid :financial_institution_id
      t.references :ledger, type: :uuid, null: false, foreign_key: { to_table: :accounting_ledgers }

      t.timestamps
    end

    add_index :accounting_accounts, :financial_institution_id
    add_index :accounting_accounts, [ :financial_institution_id, :name ], unique: true
    add_index :accounting_accounts, [ :financial_institution_id, :code ], unique: true
  end
end
