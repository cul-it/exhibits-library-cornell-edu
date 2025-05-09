# Render the thumbnail for the document
class ThumbnailComponent < Blacklight::Document::ThumbnailComponent
  # @param [Blacklight::DocumentPresenter] presenter
  # @param [Integer] counter
  # @param [Hash] image_options options for the thumbnail presenter's image tag
  def initialize(counter:, presenter: nil, document: nil, image_options: {})
    super
    @image_options = { alt: document[:full_title_tesim] || document[:id] }.merge(image_options)
  end
end
