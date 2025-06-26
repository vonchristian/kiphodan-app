class Accounting::Ledger < AccountingRecord
  include Enums::AccountTypeEnum
  attribute :financial_institution_id, :uuid

  validates :name, presence: true, length: { maximum: 255 }
  validates :code, presence: true, length: { maximum: 10 }
  validate :financial_institution_id_immutable, :account_type_immutable
  private

  def financial_institution_id_immutable
    if persisted? && financial_institution_id_changed? && financial_institution_id_was.present?
      errors.add(:financial_institution_id, "cannot be changed once set")
    end
  end

  def account_type_immutable
    if persisted? && account_type_changed? && account_type_was.present?
      errors.add(:account_type, "cannot be changed once set")
    end
  end
end
