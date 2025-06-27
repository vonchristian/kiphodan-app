FactoryBot.define do
  factory :entry_line_item, class: Accounting::EntryLineItem do
    entry { nil }
    account { nil }
    amount_cents { 1 }
    amount_currency { "PHP" }
  end
end
