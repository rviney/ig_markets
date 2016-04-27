describe IGMarkets::CLI::Main do
  let(:dealing_platform) { IGMarkets::DealingPlatform.new }

  def cli(arguments = {})
    IGMarkets::CLI::Main.new [], { username: '', password: '', api_key: '' }.merge(arguments)
  end

  before do
    IGMarkets::CLI::Main.instance_variable_set :@dealing_platform, dealing_platform

    expect(IGMarkets::CLI::Main).to receive(:begin_session).and_yield(dealing_platform)
  end

  it 'prints transactions from a recent number of days' do
    transactions = [build(:transaction)]

    expect(dealing_platform.account).to receive(:recent_transactions).with(3).and_return(transactions)

    expect { cli(days: 3, interest: true).transactions }.to output(<<-END
+------------+-----------+------+------------+------+------+-------+-------------+
|                                  Transactions                                  |
+------------+-----------+------+------------+------+------+-------+-------------+
| Date       | Reference | Type | Instrument | Size | Open | Close | Profit/loss |
+------------+-----------+------+------------+------+------+-------+-------------+
| 2015-06-23 | Reference | Deal | Instrument |   +1 |  0.8 |   0.8 |    #{'US -1.00'.red} |
+------------+-----------+------+------------+------+------+-------+-------------+

Interest: US 0.00
Profit/loss: US -1.00
END
                                                                  ).to_stdout
  end

  it 'prints transactions from a number of days and a start date' do
    start_date = Date.new 2015, 02, 15
    end_date = Date.new 2015, 02, 18

    expect(dealing_platform.account).to receive(:transactions_in_date_range).with(start_date, end_date).and_return([])

    expect { cli(days: 3, start_date: '2015-02-15', interest: true).transactions }.to output(<<-END
+------+-----------+------+------------+------+------+-------+-------------+
|                               Transactions                               |
+------+-----------+------+------------+------+------+-------+-------------+
| Date | Reference | Type | Instrument | Size | Open | Close | Profit/loss |
+------+-----------+------+------------+------+------+-------+-------------+
+------+-----------+------+------------+------+------+-------+-------------+
END
                                                                                            ).to_stdout
  end

  it 'prints transactions filtered by instrument without interest transactions' do
    transactions = [build(:transaction), build(:transaction, instrument_name: 'Test 123', profit_and_loss: 'US1.00')]

    expect(dealing_platform.account).to receive(:recent_transactions).with(3).and_return(transactions)

    expect { cli(days: 3, instrument: '123', interest: false).transactions }.to output(<<-END
+------------+-----------+------+------------+------+------+-------+-------------+
|                                  Transactions                                  |
+------------+-----------+------+------------+------+------+-------+-------------+
| Date       | Reference | Type | Instrument | Size | Open | Close | Profit/loss |
+------------+-----------+------+------------+------+------+-------+-------------+
| 2015-06-23 | Reference | Deal | Test 123   |   +1 |  0.8 |   0.8 |     #{'US 1.00'.green} |
+------------+-----------+------+------------+------+------+-------+-------------+

Profit/loss: US 1.00
END
                                                                                      ).to_stdout
  end
end