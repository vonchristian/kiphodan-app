class Accounting::Account < AccountingRecord
  NORMAL_CREDIT_BALANCE = %w[equity liability revenue].freeze
  self.table_name = "accounting_accounts"

  include Enums::AccountTypeEnum
  include ImmutableAttributes


  belongs_to :ledger, class_name: "Accounting::Ledger"
  has_many :entry_line_items, class_name: "Accounting::EntryLineItem"
  immutable_attributes :financial_institution_id, :account_type

  attribute :financial_institution_id, :uuid
  validates :financial_institution_id, presence: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :code, presence: true, length: { maximum: 10 }

  def normal_credit_balance?
    NORMAL_CREDIT_BALANCE.include?(account_type)
  end

  def balance(from: nil, to: nil)
    Accounting::BalanceCalculator.run!(account: self, from: from, to: to)
  end

def credits_balance(from: nil, to: nil)
  Accounting::BalanceCalculator.run!(account: self, from: from, to: to, balance_type: :credit)
end

def debits_balance(from: nil, to: nil)
  Accounting::BalanceCalculator.run!(account: self, from: from, to: to, balance_type: :debit)
end
end
