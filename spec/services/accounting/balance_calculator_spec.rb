require 'rails_helper'

RSpec.describe Accounting::BalanceCalculator, type: :interaction do
  let(:asset) { create(:asset_account) }
  let(:expense) { create(:expense_account) }
  let(:revenue) { create(:revenue_account) }

let!(:entry1) do
    create(:entry, posted_at: 1.day.ago).tap do |entry|
      create(:entry_line_item, entry:, account: asset, amount_cents: 3000, line_item_type: :debit)
      create(:entry_line_item,  entry:, account: revenue, amount_cents: 3000, line_item_type: :credit)
    end
  end
  let!(:entry2) do
    create(:entry, posted_at: 2.days.ago).tap do |entry|
      create(:entry_line_item, entry:, account: asset, amount_cents: 1000, line_item_type: :credit)
      create(:entry_line_item, entry:, account: expense, amount_cents: 1000, line_item_type: :debit)
    end
  end



  describe '#execute' do
    context 'when type is :net' do
      it 'returns the correct balance' do
        result = described_class.run!(account: asset)
        expect(result).to eq(2000)
      end
    end

    context 'when type is :credit' do
      it 'returns the total credits' do
        result = described_class.run!(account: asset, type: :credit)
        expect(result).to eq(3000)
      end
    end

    context 'when type is :debit' do
      it 'returns the total debits' do
        result = described_class.run!(account:, type: :debit)
        expect(result).to eq(5000)
      end
    end

    context 'with from/to filter' do
      it 'filters amounts by posted_at range' do
        result = described_class.run!(account:, from: 1.day.ago.beginning_of_day, to: 1.day.ago.end_of_day)
        expect(result).to eq(-3000)
      end
    end
  end
end
