require 'rails_helper'

RSpec.describe Accounting::EntryLineItem, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:entry).class_name('Accounting::Entry') }
    it { is_expected.to belong_to(:account).class_name('Accounting::Account') }
  end
  describe 'validations' do
    it { is_expected.to validate_presence_of(:entry) }
    it { is_expected.to validate_presence_of(:account) }
    it { is_expected.to validate_numericality_of(:amount_cents).is_greater_than_or_equal_to(0) }
  end
end
