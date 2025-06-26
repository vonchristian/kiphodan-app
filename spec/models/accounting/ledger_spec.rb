require 'rails_helper'

RSpec.describe Accounting::Ledger, type: :model do
  describe 'validations' do
    subject { build(:ledger) }

    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
    it { is_expected.to validate_length_of(:code).is_at_most(10) }
  end

  context "financial_institution_id immutability" do
    let(:original_id) { SecureRandom.uuid }
    let(:new_id) { SecureRandom.uuid }
    it "allows setting financial_institution_id when creating" do
      ledger = build(:ledger,
        name: "Cash",
        code: "CASH",
        financial_institution_id: original_id
      )
      expect(ledger).to be_valid
    end

    it "allows setting financial_institution_id if it was nil before" do
      ledger = create(:ledger, financial_institution_id: nil)
      ledger.financial_institution_id = new_id
      expect(ledger).to be_valid
    end

    it "prevents changing financial_institution_id once set" do
      ledger = FactoryBot.create(:ledger, financial_institution_id: original_id)
      ledger.financial_institution_id = new_id
      expect(ledger).not_to be_valid
      expect(ledger.errors[:financial_institution_id]).to include("cannot be changed once set")
    end
  end

  describe "account_type enum" do
    it "defines all valid account types" do
      expect(described_class.account_types.keys).to contain_exactly(
        "asset", "equity", "liability", "revenue", "expense"
      )
    end

    it "allows valid enum assignment" do
      ledger = build(:ledger, account_type: "asset")
      expect(ledger).to be_valid
    end

    it "raises error for invalid enum value" do
      expect {
        build(:ledger, account_type: "invalid_type")
      }.to raise_error(ArgumentError)
    end
  end

  describe "immutability of account_type" do
   it "prevents changing account_type once set" do
  ledger = create(:ledger, account_type: "asset", financial_institution_id: SecureRandom.uuid)

  ledger.account_type = "liability"
  expect(ledger).not_to be_valid
  expect(ledger.errors[:account_type]).to include("cannot be changed once set")
end

    it "allows updating other fields" do
      ledger = create(:ledger, account_type: "revenue")
      ledger.name = "Updated Name"
      expect(ledger).to be_valid
    end
  end
end
