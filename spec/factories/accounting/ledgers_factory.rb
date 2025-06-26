FactoryBot.define do
  factory :ledger, class: Accounting::Ledger do
    name { Faker::Company.industry }
    code { Faker::Alphanumeric.alphanumeric(number: 6).upcase }
    contra { false }
    account_type { "asset" }
  end
end
