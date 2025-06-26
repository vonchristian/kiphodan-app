class CreateFinancialInstitutions < ActiveRecord::Migration[8.0]
  def change
    create_table :financial_institutions, id: :uuid do |t|
      t.string :full_name, null: false
      t.string :abbreviated_name, null: false
      t.timestamps
    end
    add_index :financial_institutions, :abbreviated_name, unique: true
  end
end
