# frozen_string_literal: true

class ErrorsController < ApplicationController
  def unauthorized
    render status: 401
  end

  def not_found
    render status: 404
  end

  def internal_error
    render status: 500
  end
end
