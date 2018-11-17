require_relative '../../automated_init'

context "Handle Account Events" do
  context "Account Withdrawn Rejected" do
    context "Failed" do
      handler = Handlers::Account::Events.new

      processed_time = Controls::Time::Processed::Raw.example

      handler.clock.now = processed_time

      account_withdrawal_rejected = Account::Client::Controls::Events::WithdrawalRejected.example

      funds_transfer = Controls::FundsTransfer::Initiated.example
      refute(funds_transfer.completed?)

      handler.store.add(funds_transfer.id, funds_transfer)

      funds_transfer_stream_name = "fundsTransfer-#{funds_transfer.id}"
      account_withdrawal_rejected.metadata.correlation_stream_name = funds_transfer_stream_name

      original_correlation_stream = funds_transfer.original_correlation_stream
      # account_id = account_withdrawn.account_id or fail
      # amount = account_withdrawn.amount or fail
      # effective_time = account_withdrawn.time or fail

      handler.(account_withdrawal_rejected)

      writer = handler.write

      failed = writer.one_message do |event|
        event.instance_of?(Messages::Events::Failed)
      end

      test "Withdrawn event is written" do
        refute(failed.nil?)
      end

      test "Written to the funds transfer stream" do
        written_to_stream = writer.written?(failed) do |stream_name|
          stream_name == funds_transfer_stream_name
        end

        assert(written_to_stream)
      end

      context "Attributes" do
        test "failure reason" do
          assert(failed.reason == 'Withdrawal rejected')
        end

        test 'time' do
          assert(failed.time == Clock.iso8601(processed_time))
        end

        test 'funds_transfer_id' do
          assert(failed.funds_transfer_id == funds_transfer.id)
        end

        test 'restores original correlation stream' do
          assert(failed.metadata.correlation_stream_name == original_correlation_stream)
        end

      end
    end
  end
end
