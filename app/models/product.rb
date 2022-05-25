class Product < ApplicationRecord
  has_many :product_discounts, dependent: :destroy

  validates :name, :default_price, :currency, :quantity, :active, presence: true
end
