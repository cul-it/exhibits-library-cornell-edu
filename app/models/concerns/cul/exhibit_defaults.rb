# frozen_string_literal: true

# CUL customizations of default exhibit configurations
module Cul
  module ExhibitDefaults
    extend ActiveSupport::Concern

    included do
      before_save :set_published_at
    end

    def set_published_at
      self.published_at = Time.zone.now if published? && published_changed?
    end
  end
end
