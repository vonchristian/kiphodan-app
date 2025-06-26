class FinancialInstitutionsRecord < ApplicationRecord
  self.abstract_class = true

  connects_to database: { writing: :financial_institutions }
end
