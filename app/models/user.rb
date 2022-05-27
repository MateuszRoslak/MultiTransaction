# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :addresses, dependent: :destroy
  has_many :cards, dependent: :destroy
  has_many :line_items, dependent: :destroy

  has_one :wallet, dependent: :destroy

  validates :first_name, :last_name, :phone, presence: true
end
