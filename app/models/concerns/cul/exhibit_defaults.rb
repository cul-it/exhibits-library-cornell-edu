# frozen_string_literal: true

# CUL customizations of default exhibit configurations
module Cul
  module ExhibitDefaults
    extend ActiveSupport::Concern

    included do
      before_save :set_published
    end

    def set_published
      return unless published? && published_changed?

      # Don't reset weight if previously published
      self.weight = 0 unless published_at

      # Set published_at date
      self.published_at = Time.zone.now
    end
  end
end
