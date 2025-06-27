class Accounting::Entry < AccountingRecord
  self.table_name = "accounting_entries"
  has_many :line_items, class_name: "Accounting::EntryLineItem"
  validates :reference_number, :description, presence: true, length: { maximum: 255 }
end
