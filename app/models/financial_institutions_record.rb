class FinancialInstitutionsRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :financial_institutions_primary, reading: :financial_institutions_replica }
end
