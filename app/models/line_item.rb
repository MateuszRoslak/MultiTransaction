class LineItem < ApplicationRecord
  belongs_to :user
  belongs_to :product

  validates :quantity, presence: true
  validates :product, uniqueness: { scope: :user }
end
