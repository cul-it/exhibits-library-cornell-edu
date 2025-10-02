# Overrides Blacklight::Gallery::OpenseadragonEmbedComponent to set osd imageLoaderLimit and initialPage configurations
class OpenseadragonEmbedComponent < Blacklight::Gallery::OpenseadragonEmbedComponent
  def initialize(initial_page: 0, **kwargs)
    super

    @initial_page = initial_page
  end

  def osd_config
    {
      crossOriginPolicy: false,
      zoomInButton: "#{@id_prefix}-zoom-in",
      zoomOutButton: "#{@id_prefix}-zoom-out",
      homeButton: "#{@id_prefix}-home",
      fullPageButton: "#{@id_prefix}-full-page",
      nextButton: "#{@id_prefix}-next",
      previousButton: "#{@id_prefix}-previous",
      # Downloads one image at a time, so that the initial image tile is rendered before additional tiles
      imageLoaderLimit: 1
    }
  end

  def osd_config_referencestrip
    {
      # Set Reference Strip initial page to default to first page
      initialPage: @initial_page,
      showReferenceStrip: true,
      sequenceMode: true,
      referenceStripScroll: 'vertical',
      referenceStripBackgroundColor: 'transparent'
    }
  end
end
