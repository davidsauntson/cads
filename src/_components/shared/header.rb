module Shared
  class Header < ViewComponent::Base
    include Bridgetown::ViewComponentHelpers

    def initialize(title:, description:)
      @title, @description = title, description
    end
  end
end