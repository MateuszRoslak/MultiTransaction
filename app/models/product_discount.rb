# frozen_string_literal: true

class ProductDiscount < ApplicationRecord
  include CardTypeEnum
  include HasTaxesCalculation
  attribute :discount_price, PriceType.new

  before_validation -> { calculate_tax_value(discount_price) if discount_price }

  belongs_to :product
  has_many :line_items, dependent: :nullify

  validates :discount_price, :card_type, presence: true

  enum card_type: CardTypeEnum::VALUES, _prefix: true

  scope :join_user_discounts,
        lambda { |user|
          joins("INNER JOIN cards c ON c.card_type = product_discounts.card_type AND c.user_id = #{user.id}")
        }
end
