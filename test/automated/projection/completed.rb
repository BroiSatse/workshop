require_relative '../automated_init'

context "Projection" do
  context "Completed" do
    funds_transfer = Controls::FundsTransfer::New.example

    assert(funds_transfer.completion_time.nil?)

    completed = Controls::Events::Completed.example

    funds_transfer_id = completed.funds_transfer_id or fail
    completion_time_iso8601 = completed.time

    Projection.(funds_transfer, completed)

    test "ID is set" do
      assert(funds_transfer.id == funds_transfer_id)
    end

    test "Initiated time is converted and set" do
      completion_time = Clock.parse(completion_time_iso8601)

      assert(funds_transfer.completion_time == completion_time)
    end
  end
end
