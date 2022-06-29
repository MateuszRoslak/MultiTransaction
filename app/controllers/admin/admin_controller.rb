# frozen_string_literal: true

module Admin
  class AdminController < ActionController::Base
    include ApplicationHelper
    prepend_view_path 'app/views/admin'
    layout 'admin'
  end
end
