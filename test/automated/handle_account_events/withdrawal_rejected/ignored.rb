require_relative '../../automated_init'

context "Handle Account Events" do
  context "Account Withdrawal Rejected" do
    context "Ignored" do
      handler = Handlers::Account::Events.new

      account_withdrawal_rejected = Account::Client::Controls::Events::WithdrawalRejected.example

      funds_transfer_id = Controls::FundsTransfer.id
      funds_transfer_stream_name = "fundsTransfer-#{funds_transfer_id}"
      account_withdrawal_rejected.metadata.correlation_stream_name = funds_transfer_stream_name

      funds_transfer = Controls::FundsTransfer.example
      assert(funds_transfer.completed?)

      handler.store.add(funds_transfer.id, funds_transfer)

      handler.(account_withdrawal_rejected)

      writer = handler.write

      failed = writer.one_message do |event|
        event.instance_of?(Messages::Events::Failed)
      end

      test "Withdrawn event is not written" do
        assert(failed.nil?)
      end
    end
  end
end
