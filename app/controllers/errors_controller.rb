# frozen_string_literal: true

class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!

  def unauthorized
    render status: :unauthorized
  end

  def not_found
    render status: :not_found
  end

  def internal_error
    render status: :internal_server_error
  end
end
