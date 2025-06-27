FactoryBot.define do
  factory :account, class: Accounting::Account do
    name { Faker::Company.industry }
    code { Faker::Alphanumeric.alphanumeric(number: 6).upcase }
    contra { false }
    account_type { "asset" }
    financial_institution_id { SecureRandom.uuid }
    association :ledger

    factory :asset_account do
      account_type { "asset" }
    end

    factory :liability_account do
      account_type { "liability" }
    end

    factory :equity_account do
      account_type { "equity" }
    end

    factory :revenue_account do
      account_type { "revenue" }
    end

    factory :expense_account do
      account_type { "expense" }
    end
  end
end
