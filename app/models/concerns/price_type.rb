# frozen_string_literal: true

class PriceType < ActiveModel::Type::Integer
  private

  def cast_value(value)
    if value.is_a? String
      value.delete(',.').to_i
    else
      value.to_i
    end
  end
end
