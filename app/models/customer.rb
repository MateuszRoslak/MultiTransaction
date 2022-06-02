# frozen_string_literal: true

class Customer < ApplicationRecord
  belongs_to :user

  validates :processor, presence: true
  validates :processor, uniqueness: { scope: :processor_id }
end
