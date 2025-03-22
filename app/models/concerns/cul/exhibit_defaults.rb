# frozen_string_literal: true

# CUL customizations of default exhibit configurations
module Cul
  module ExhibitDefaults
    extend ActiveSupport::Concern

    included do
      before_save :set_published
      after_save :check_publish_change
    end

    def set_published
      @was_published = published_was
      return unless published? && published_changed?

      # Don't reset weight if previously published
      self.weight = 0 unless published_at

      # Set published_at date
      self.published_at = Time.zone.now
    end

    def check_publish_change
      return unless !@was_published && published?
      Rails.logger.info("Exhibit #{id}: #{title} has been published, emailing notification")
      send_publish_notification
    end

    def send_publish_notification
      ExhibitStatusMailer.exhibit_published(self).deliver_later
    rescue StandardError => e
      Rails.logger.error("**** EMAIL FAILURE on publish notification for exhibit #{id} #{title}: #{e.message}")
    end
  end
end
