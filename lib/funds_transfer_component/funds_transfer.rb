module FundsTransferComponent
  class FundsTransfer
    include Schema::DataStructure

    attribute :id, String
    attribute :withdrawal_account_id, String
    attribute :deposit_account_id, String
    attribute :withdraw_id, String
    attribute :deposit_id, String
    attribute :amount, Numeric
    attribute :initiated_time, Time
    attribute :withdrawn_time, Time
    attribute :deposited_time, Time
    attribute :completion_time, Time
    attribute :original_correlation_stream, String

    def initiated?
      !initiated_time.nil?
    end

    def withdrawn?
      !withdrawn_time.nil?
    end

    def deposited?
      !deposited_time.nil?
    end

    def completed?
      !completion_time.nil?
    end
  end
end
