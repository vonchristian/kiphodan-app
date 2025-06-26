module Enums::AccountTypeEnum
  extend ActiveSupport::Concern

  included do
    enum :account_type, {
      asset: "asset",
      equity: "equity",
      liability: "liability",
      revenue: "revenue",
      expense: "expense"
    }, prefix: true

    validates :account_type, presence: true
  end
end
