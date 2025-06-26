class AccountingRecord < ActiveRecord::Base
  self.abstract_class = true
  connects_to database: { writing: :accounting, reading: :accounting_replica }
end
