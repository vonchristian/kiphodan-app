FactoryBot.define do
  factory :entry, class: Accounting::Entry do
    posted_at { "2025-06-27 20:25:16" }
    reference_number { "MyString" }
    description { "MyString" }
  end
end
