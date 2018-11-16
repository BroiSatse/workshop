module FundsTransferComponent
  module Controls
    module Events
      module Completed
        def self.example
          completed = FundsTransferComponent::Messages::Events::Completed.build

          completed.funds_transfer_id = FundsTransfer.id
          completed.time = Time::Effective.example

          completed
        end
      end
    end
  end
end
