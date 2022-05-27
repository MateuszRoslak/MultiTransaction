# frozen_string_literal: true

class Address < ApplicationRecord
  belongs_to :user

  validates :country, :city, :street, :building, :zip_code, :default, presence: true
end
