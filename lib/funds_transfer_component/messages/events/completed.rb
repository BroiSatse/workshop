module FundsTransferComponent
  module Messages
    module Events
      class Completed
        include Messaging::Message

        attribute :funds_transfer_id, String
        attribute :time, String
      end
    end
  end
end
