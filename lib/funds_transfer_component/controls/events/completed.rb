module FundsTransferComponent
  module Controls
    module Events
      module Completed
        def self.example
          initiated = FundsTransferComponent::Messages::Events::Completed.build

          initiated.funds_transfer_id = FundsTransfer.id
          initiated.time = Time::Effective.example

          initiated
        end
      end
    end
  end
end
