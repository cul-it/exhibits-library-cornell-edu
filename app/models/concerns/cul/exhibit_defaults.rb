# frozen_string_literal: true

# CUL customizations of default exhibit configurations
module Cul
  module ExhibitDefaults
    extend ActiveSupport::Concern

    included do
      before_save :set_published
      after_save :send_status_notification
      after_save :add_dublin_core_metadata
    end

    def set_published
      return unless published? && published_changed?

      # Don't reset weight if previously published
      self.weight = 0 unless published_at

      # Set published_at date
      self.published_at = Time.zone.now
    end

    def send_status_notification
      return unless saved_change_to_published?
      ExhibitStatusMailer.send_exhibit_status_email(self).deliver_later
    end

    def add_dublin_core_metadata
      # Limit to new exhibits to avoid adding fields if the exhibit is updated or published after creation
      return unless previously_new_record?

      # Add Qualified Dublin Core fields (using DCMI Metadata Terms)
      dublin_core_fields = [
        { dcterms: 'creator', field_type: 'vocab', is_multiple: true },
        { dcterms: 'contributor', field_type: 'vocab', is_multiple: true },
        { dcterms: 'created', field_type: 'vocab', is_multiple: true },
        { dcterms: 'issued', field_type: 'vocab', is_multiple: true },
        { dcterms: 'language', field_type: 'vocab', is_multiple: true },
        { dcterms: 'spatial', field_type: 'vocab', is_multiple: true },
        { dcterms: 'publisher', field_type: 'vocab', is_multiple: true },
        { dcterms: 'subject', field_type: 'vocab', is_multiple: true },
        { dcterms: 'temporal', field_type: 'vocab', is_multiple: true },
        { dcterms: 'type', field_type: 'vocab', is_multiple: false },
        { dcterms: 'extent', field_type: 'text', is_multiple: false },
        { dcterms: 'format', field_type: 'text', is_multiple: false },
        { dcterms: 'relation', field_type: 'text', is_multiple: false },
        { dcterms: 'source', field_type: 'text', is_multiple: false },
        { dcterms: 'identifier', field_type: 'vocab', is_multiple: true }
      ]

      dublin_core_fields.each do |field|
        suffix = Spotlight::Engine.config.custom_field_types[field[:field_type].to_sym][:suffix] || Spotlight::Engine.config.solr_fields.text_suffix
        
        Spotlight::CustomField.new(
          exhibit: self,
          field: "dcterms_#{field[:dcterms]}#{suffix}",
          label: I18n.t("spotlight.search.fields.dcterms.labels.#{field[:dcterms]}", default: field[:dcterms].humanize),
          short_description: I18n.t("spotlight.search.fields.dcterms.short_descriptions.#{field[:dcterms]}", default: nil),
          field_type: field[:field_type],
          is_multiple: field[:is_multiple]
        ).save!
      end
    end
  end
end
