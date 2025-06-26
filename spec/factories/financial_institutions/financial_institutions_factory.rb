FactoryBot.define do
  factory :financial_institution, class: FinancialInstitutions::FinancialInstitution do
    full_name { Faker::Company.name }
    abbreviated_name do
      full_name.split.map { |word| word[0] }.join.upcase
    end
  end
end
