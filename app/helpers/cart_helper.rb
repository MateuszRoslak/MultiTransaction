# frozen_string_literal: true

module CartHelper
  def get_line_item_price(line_item)
    line_item.quantity * line_item.product.default_price
  end
end
