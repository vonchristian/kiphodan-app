class FinancialInstitutions::FinancialInstitution < FinancialInstitutionsRecord
  validates :full_name, presence: true, length: { maximum: 255 }
  validates :abbreviated_name, presence: true, length: { maximum: 10 }
  validates :abbreviated_name, uniqueness: true
end
