# frozen_string_literal: true

# Overrides Spotlight::SolrDocumentLegacyEmbedComponent to pass initial_page into embed_component
class SolrDocumentLegacyEmbedComponent < Spotlight::SolrDocumentLegacyEmbedComponent
  attr_reader :initial_page

  def initialize(initial_page: 0, **kwargs)
    @initial_page = initial_page
    super
  end

  def before_render
    with_embed(initial_page: @initial_page) unless embed
    super
  end
end
