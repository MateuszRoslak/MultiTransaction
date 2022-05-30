# frozen_string_literal: true

class ApplicationService
  include Rails.application.routes.url_helpers

  def self.call(...)
    new.call(...)
  end

  def default_url_options
    Rails.application.config.action_mailer.default_url_options
  end
end
