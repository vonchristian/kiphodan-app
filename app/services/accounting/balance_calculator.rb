# frozen_string_literal: true

module Accounting
  class BalanceCalculator < ActiveInteraction::Base
    object :account, class: Accounting::Account
    date_time :from, default: nil
    date_time :to, default: nil
    symbol :balance_type, default: :net

    def execute
      scope = account.entry_line_items.joins(:entry)
      scope = scope.where(entries: { posted_at: from..to }) if from || to

      case balance_type
      when :credit
        scope.credit.sum(:amount_cents)
      when :debit
        scope.debit.sum(:amount_cents)
      else
        credits = scope.credit.sum(:amount_cents)
        debits  = scope.debit.sum(:amount_cents)
        account.normal_credit_balance? != account.contra? ? credits - debits : debits - credits
      end
    end
  end
end
