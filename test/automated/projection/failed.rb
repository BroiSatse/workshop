require_relative '../automated_init'

context "Projection" do
  context "Failed" do
    funds_transfer = Controls::FundsTransfer::New.example

    assert(funds_transfer.completion_time.nil?)

    failed = Controls::Events::Failed.example

    funds_transfer_id = failed.funds_transfer_id or fail
    completion_time_iso8601 = failed.time

    Projection.(funds_transfer, failed)

    test "ID is set" do
      assert(funds_transfer.id == funds_transfer_id)
    end

    test "Competion time is converted and set" do
      completion_time = Clock.parse(completion_time_iso8601)

      assert(funds_transfer.completion_time == completion_time)
    end
  end
end
