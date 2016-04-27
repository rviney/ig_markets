module IGMarkets
  module CLI
    # Helper class that prints out an array of {IGMarkets::Transaction} instances in a table.
    class TransactionsTable < Table
      private

      def default_title
        'Transactions'
      end

      def headings
        ['Date', 'Reference', 'Type', 'Instrument', 'Size', 'Open', 'Close', 'Profit/loss']
      end

      def right_aligned_columns
        [4, 5, 6, 7]
      end

      def row(transaction)
        [transaction.date, transaction.reference, formatted_type(transaction.transaction_type),
         transaction.instrument_name, transaction.size, Format.level(transaction.open_level),
         Format.level(transaction.close_level),
         Format.currency(transaction.profit_and_loss_amount, transaction.currency)]
      end

      def cell_color(value, _transaction, _row_index, column_index)
        return unless headings[column_index] == 'Profit/loss'

        if value =~ /-/
          :red
        else
          :green
        end
      end

      def formatted_type(type)
        { deal: 'Deal', depo: 'Deposit', dividend: 'Dividend', exchange: 'Exchange', with: 'Withdrawal' }.fetch type
      end
    end
  end
end