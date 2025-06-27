class AccountingRecord < ActiveRecord::Base
  self.abstract_class = true
  connects_to database: { writing: :accounting_primary, reading: :accounting_replica }
end
