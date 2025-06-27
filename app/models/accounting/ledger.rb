class Accounting::Ledger < AccountingRecord
  include Enums::AccountTypeEnum
  include ImmutableAttributes

  immutable_attributes :financial_institution_id, :account_type
  attribute :financial_institution_id, :uuid

  validates :financial_institution_id, presence: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :code, presence: true, length: { maximum: 10 }
end
