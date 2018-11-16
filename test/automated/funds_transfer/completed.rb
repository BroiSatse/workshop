require_relative '../automated_init'

context "Funds Transfer" do
  context "Has Completion Time" do
    funds_transfer = Controls::FundsTransfer.example

    refute(funds_transfer.completion_time.nil?)

    test "Is despoited" do
      assert(funds_transfer.completed?)
    end
  end

  context "Does Not Have Deposited Time" do
    funds_transfer = Controls::FundsTransfer::New.example

    assert(funds_transfer.completion_time.nil?)

    test "Is not deposited" do
      refute(funds_transfer.completed?)
    end
  end
end
