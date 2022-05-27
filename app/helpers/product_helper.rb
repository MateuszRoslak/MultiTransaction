# frozen_string_literal: true

module ProductHelper
  def format_price(currency, price)
    "#{currency.upcase} #{price.to_f / 100}"
  end
end
