describe IGMarkets::CLI::Tables::WorkingOrdersTable do
  it 'prints working orders' do
    working_orders = [build(:working_order)]

    expect(described_class.new(working_orders).to_s).to eql(<<-MSG.strip
+-------------------------+-------------------+----------+-------+-----------+------+-------+----------------+---------------+-------------------------+---------+
|                                                                         Working orders                                                                         |
+-------------------------+-------------------+----------+-------+-----------+------+-------+----------------+---------------+-------------------------+---------+
| Created date            | EPIC              | Currency | Type  | Direction | Size | Level | Limit distance | Stop distance | Good till date          | Deal ID |
+-------------------------+-------------------+----------+-------+-----------+------+-------+----------------+---------------+-------------------------+---------+
| 2014-10-20 13:30:03 UTC | UA.D.AAPL.CASH.IP | USD      | Limit | Buy       |    1 | 100.0 |             10 |            10 | 2015-10-30 12:59:00 UTC | DEAL    |
+-------------------------+-------------------+----------+-------+-----------+------+-------+----------------+---------------+-------------------------+---------+
MSG
                                                           )
  end
end
