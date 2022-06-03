# frozen_string_literal: true

module CartHelper
  def get_line_item_price(line_item)
    if line_item.product_discount
      line_item.quantity * line_item.product_discount.discount_price
    else
      line_item.quantity * line_item.product.default_price
    end
  end
end
