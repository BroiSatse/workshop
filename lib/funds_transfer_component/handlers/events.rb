module FundsTransferComponent
  module Handlers
    class Events
      include Log::Dependency
      include Messaging::Handle
      include Messaging::StreamName
      include Messages::Commands
      include Messages::Events

      dependency :store, Store

      dependency :withdraw, ::Account::Client::Withdraw
      dependency :deposit, ::Account::Client::Deposit


      def configure
        ::Account::Client::Withdraw.configure(self)
        ::Account::Client::Deposit.configure(self)
      end

      category :funds_transfer

      handle Initiated do |initiated|
        account_id = initiated.withdrawal_account_id
        withdrawal_id = initiated.withdrawal_id
        amount = initiated.amount

        withdraw.(
          withdrawal_id: withdrawal_id,
          account_id: account_id,
          amount: amount,
          previous_message: initiated
        )
      end

      handle Withdrawn do |withdrawn|
        transfer_id = withdrawn.funds_transfer_id
        transfer = store.fetch transfer_id

        deposit.(
          deposit_id: transfer.deposit_id,
          account_id: transfer.deposit_account_id,
          amount: transfer.amount,
          previous_message: withdrawn
        )
      end
    end
  end
end
