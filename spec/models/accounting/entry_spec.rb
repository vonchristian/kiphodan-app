require 'rails_helper'

RSpec.describe Accounting::Entry, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:line_items).class_name('Accounting::EntryLineItem') }
  end
  describe 'validations' do
    subject { build(:entry) }

    it { is_expected.to validate_presence_of(:reference_number) }
    it { is_expected.to validate_presence_of(:description) }
    it { is_expected.to validate_length_of(:reference_number).is_at_most(255) }
    it { is_expected.to validate_length_of(:description).is_at_most(255) }
  end
end
