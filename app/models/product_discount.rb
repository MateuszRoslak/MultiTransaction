# frozen_string_literal: true

class ProductDiscount < ApplicationRecord
  belongs_to :product
  has_many :line_items, dependent: :nullify 
  
  validates :discount_price, :card_type, presence: true

  #enum card_type: %i[multisport ok_system], _prefix: true

  # scope :best_discount, 
  #       lambda{|user| 
  #         join_user_discounts(user).order(:discount_price).first}
  scope :join_user_discounts, 
        lambda{|user| 
          joins("LEFT JOIN cards c ON c.card_type = product_discounts.card_type").where("c.user_id = #{user.id}")}
end
