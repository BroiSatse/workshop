require_relative '../../automated_init'

context "Handle Events" do
  context "Deposited" do
    context "Completed" do
      handler = Handlers::Events.new

      deposited = Controls::Events::Deposited.example
      funds_transfer_id = deposited.funds_transfer_id
      transfer_stream_name = "fundsTransfer-#{funds_transfer_id}"
      deposited.metadata.correlation_stream_name = transfer_stream_name

      transfer = Controls::FundsTransfer.example
      refute(transfer.completion_time.nil?)

      handler.store.add(funds_transfer_id, transfer)

      handler.(deposited)

      writer = handler.write

      completed = writer.one_message do |event|
        event.instance_of?(FundsTransfer::Messages::Events::Completed)
      end

      test "Completed event is not written" do
        assert(completed.nil?)
      end
    end
  end
end
