require_relative '../../automated_init'

context "Handle Events" do
  context "Deposited" do
    context "Completed" do
      handler = Handlers::Events.new

      processed_time = Controls::Time::Processed::Raw.example

      Deposited = Controls::Events::Withdrawn.example
      funds_transfer_id = withdrawn.funds_transfer_id
      withdrawn.metadata.correlation_stream_name = "fundsTransfer-#{funds_transfer_id}"

      transfer = FundsTransfer.new
      deposit_account_id = transfer.deposit_account_id = Identifier::UUID.random
      deposit_id = transfer.deposit_id = Identifier::UUID.random
      transfer.amount = amount = withdrawn.amount

      handler.store.put(funds_transfer_id, transfer)

      account_command_stream_name = "account:command-#{deposit_account_id}"

      handler.(withdrawn)

      writer = deposit_client.write

      deposit = writer.one_message do |event|
        event.instance_of?(Account::Client::Messages::Commands::Deposit)
      end

      test "Deposit command is written" do
        refute(deposit.nil?)
      end

      test "Written to the account command stream" do
        written_to_stream = writer.written?(deposit) do |stream_name|
          stream_name == account_command_stream_name
        end

        assert(written_to_stream)
      end

      context "Attributes" do
        test "withdrawal_id" do
          assert(deposit.deposit_id == deposit_id)
        end

        test "account_id" do
          assert(deposit.account_id == deposit_account_id)
        end

        test "amount" do
          require 'byebug'
          assert(deposit.amount == amount)
        end
      end

      context "Metadata" do
        test "Follows previous message" do
          assert(deposit.metadata.correlation_stream_name == withdrawn.metadata.correlation_stream_name)
        end
      end
    end
  end
end
