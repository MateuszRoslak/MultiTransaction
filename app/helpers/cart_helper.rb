# frozen_string_literal: true

module CartHelper
  def get_line_item_price(line_item)
    line_item.product_discount ? line_item.product_discount.discount_price : line_item.product.default_price
  end

  def get_line_item_tax(line_item)
    line_item.product_discount ? line_item.product_discount.tax_value : line_item.product.tax_value
  end

  def get_line_item_final_price(line_item)
    line_item.quantity * get_line_item_price(line_item)
  end

  def get_line_item_final_tax(line_item)
    line_item.quantity * get_line_item_tax(line_item)
  end

  def get_final_price(line_items)
    line_items.total_value - line_items.total_discount_value
  end

  def get_final_tax(line_items)
    line_items.total_tax_value - line_items.total_discount_tax_value
  end

  def get_final_net(line_items)
    get_final_price(line_items) - get_final_tax(line_items)
  end
end
