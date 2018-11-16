module FundsTransferComponent
  module Controls
    module Events
      module Failed
        def self.example
          failed = FundsTransferComponent::Messages::Events::Failed.build

          failed.funds_transfer_id = FundsTransfer.id
          failed.time = Time::Effective.example
          failed.reason = 'Some interesting reason'

          failed
        end
      end
    end
  end
end
