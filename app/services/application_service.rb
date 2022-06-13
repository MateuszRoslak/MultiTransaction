# frozen_string_literal: true

require 'dry/matcher/result_matcher'

class ApplicationService
  include Dry::Monads[:result, :do]

  def self.inherited(subclass)
    super
    subclass.include(Dry::Matcher.for(:call, with: Dry::Matcher::ResultMatcher))
  end
end
