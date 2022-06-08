# frozen_string_literal: true

class Order < ApplicationRecord
  before_validation :generate_order_number

  belongs_to :user
  has_many :order_items, dependent: :destroy

  validates :number, :currency, :item_quantity, :items_total, :items_total_net, :tax_total, :discount_total,
            presence: true
  validates :number, uniqueness: true

  private

  def generate_order_number
    self.number = 9.times.map { [*0..9].sample }.join.to_i
    self.class.find_by(number:) ? generate_order_number : number
  end
end
