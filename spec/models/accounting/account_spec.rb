require "rails_helper"

RSpec.describe Accounting::Account, type: :model do
  describe "associations" do
    it { is_expected.to belong_to(:ledger).class_name("Accounting::Ledger") }
  end

  describe "validations" do
    subject { build(:asset_account) }

    it { is_expected.to validate_presence_of(:financial_institution_id) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_length_of(:name).is_at_most(255) }
    it { is_expected.to validate_presence_of(:code) }
    it { is_expected.to validate_length_of(:code).is_at_most(10) }
  end

  describe "immutable attributes" do
    let(:account) do
      create(
        :asset_account,
        financial_institution_id: SecureRandom.uuid
      )
    end

    it "prevents financial_institution_id from being changed" do
      expect {
        account.update!(financial_institution_id: SecureRandom.uuid)
      }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Financial institution cannot be changed once set")
    end

    it "prevents account_type from being changed" do
      expect {
        account.update!(account_type: "liability")
      }.to raise_error(ActiveRecord::RecordInvalid, "Validation failed: Account type cannot be changed once set")
    end
  end
end
