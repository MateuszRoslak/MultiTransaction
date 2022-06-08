# frozen_string_literal: true

module OrderHelper
  def format_timestamp_to_db(timestamp)
    Time.at(timestamp).to_time.to_fs(:db)
  end
end
