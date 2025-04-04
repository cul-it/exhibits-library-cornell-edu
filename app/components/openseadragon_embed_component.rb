# Overrides Blacklight::Gallery::OpenseadragonEmbedComponent to set osd initialPage setting, default to first page
class OpenseadragonEmbedComponent < Blacklight::Gallery::OpenseadragonEmbedComponent
  def initialize(initial_page: 0, **kwargs)
    super

    @initial_page = initial_page
  end

  def osd_config_referencestrip
    {
      initialPage: @initial_page,
      showReferenceStrip: true,
      sequenceMode: true,
      referenceStripScroll: 'vertical',
      referenceStripBackgroundColor: 'transparent'
    }
  end
end
