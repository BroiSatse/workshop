module FundsTransferComponent
  module Handlers
    class Events
      include Log::Dependency
      include Messaging::Handle
      include Messaging::StreamName
      include Messages::Commands
      include Messages::Events

      dependency :store, Store
      dependency :clock, Clock::UTC
      dependency :write, Messaging::Postgres::Write

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

      handle Deposited do |deposited|
        transfer_id = deposited.funds_transfer_id
        transfer = store.fetch transfer_id

        stream_name = stream_name(transfer_id)
        completed = Completed.follow(deposited, copy: %i[funds_transfer_id])
        completed.time = clock.iso8601
        completed.metadata.correlation_stream_name = transfer.original_correlation_stream
        write.(completed, stream_name)
      end
    end
  end
end
