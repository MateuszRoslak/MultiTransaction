module StripeHelper
  def format_timestamp_to_db(timestamp)
    Time.at(timestamp).to_time.to_fs(:db)
  end

  def format_price(currency, amount)
    "#{currency.upcase} #{amount.to_f / 100}"
  end
end

