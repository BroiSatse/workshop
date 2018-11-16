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
      original_correlation_stream = transfer.original_correlation_stream = 'SomeCorrelation-123'
      handler.store.add(funds_transfer_id, transfer)

      handler.(deposited)

      writer = handler.write

      completed = writer.one_message do |event|
        event.instance_of?(FundsTransfer::Messages::Events::Completed)
      end

      test "Deposit command is written" do
        refute(completed.nil?)
      end

      test "Written to the account command stream" do
        written_to_stream = writer.written?(completed) do |stream_name|
          stream_name == transfer_stream_name
        end

        assert(written_to_stream)
      end

      context 'Metadata' do
        test 'Restored correlation stream to stream stored in entity' do
          assert(completed.metadata.correlation_stream_name == original_correlation_stream)
        end
      end
    end
  end
end
