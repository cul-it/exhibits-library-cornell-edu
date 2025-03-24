# frozen_string_literal: true

# CUL customizations of default exhibit configurations
module Cul
  module ExhibitDefaults
    extend ActiveSupport::Concern

    included do
      before_save :set_published
      after_save :send_publish_notification
    end

    def set_published
      return unless published? && published_changed?

      # Don't reset weight if previously published
      self.weight = 0 unless published_at

      # Set published_at date
      self.published_at = Time.zone.now
    end

    def send_publish_notification
      ExhibitStatusMailer.exhibit_published(self).deliver_later if published? && saved_change_to_published?
    end
  end
end
