module FundsTransferComponent
  module Messages
    module Events
      class Failed
        include Messaging::Message

        attribute :funds_transfer_id, String
        attribute :reason, String
        attribute :time, String
      end
    end
  end
end
