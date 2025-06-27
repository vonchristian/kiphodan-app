class Accounting::EntryLineItem < AccountingRecord
  self.table_name = "accounting_entry_line_items"

  enum :line_item_type, { debit: "debit", credit: "credit" }

  monetize :amount_cents

  belongs_to :entry
  belongs_to :account

  validates :entry, presence: true
  validates :account, presence: true
  validates :amount_cents, numericality: { greater_than_or_equal_to: 0 }
end
