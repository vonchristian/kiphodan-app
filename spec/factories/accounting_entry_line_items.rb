FactoryBot.define do
  factory :accounting_entry_line_item do
    entry { nil }
    account { nil }
    amount_cents { 1 }
    currency { "MyString" }
  end
end
