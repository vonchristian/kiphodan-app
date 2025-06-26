require 'rails_helper'

RSpec.describe FinancialInstitutions::FinancialInstitution, type: :model do
  subject { build(:financial_institution) }

  describe 'validations' do
    it { is_expected.to validate_presence_of(:full_name) }
    it { is_expected.to validate_presence_of(:abbreviated_name) }
    it { is_expected.to validate_length_of(:full_name).is_at_most(255) }
    it { is_expected.to validate_length_of(:abbreviated_name).is_at_most(10) }
  end
end
