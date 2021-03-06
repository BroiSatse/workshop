require_relative '../../automated_init'

context "Handle Account Events" do
  context "Account Deposited" do
    context "Ignored" do
      handler = Handlers::Account::Events.new

      account_deposited = Account::Client::Controls::Events::Deposited.example

      funds_transfer_id = Controls::FundsTransfer.id
      funds_transfer_stream_name = "fundsTransfer-#{funds_transfer_id}"
      account_deposited.metadata.correlation_stream_name = funds_transfer_stream_name

      funds_transfer = Controls::FundsTransfer.example
      assert(funds_transfer.deposited?)

      handler.store.add(funds_transfer.id, funds_transfer)

      handler.(account_deposited)

      writer = handler.write

      deposited = writer.one_message do |event|
        event.instance_of?(Messages::Events::Deposited)
      end

      test "Withdrawn event is not written" do
        assert(deposited.nil?)
      end
    end
  end
end
