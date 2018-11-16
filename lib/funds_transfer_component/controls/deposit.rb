module FundsTransferComponent
  module Controls
    module Deposit
      def self.id
        ID.example(increment: id_increment)
      end

      def self.id_increment
        53
      end

      module Account
        def self.id
          ID.example(increment: id_increment)
        end

        def self.id_increment
          2222
        end
      end
    end
  end
end
