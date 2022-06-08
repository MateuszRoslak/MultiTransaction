# frozen_string_literal: true

module ProductHelper
  def format_price(currency, price)
    "#{currency.upcase} #{number_with_precision((price.to_f / 100), precision: 2)}"
  end
end
