# frozen_string_literal: true

# Based on the Module#prepend pattern in ruby.
# Uses the to_prepare Rails hook in application.rb to inject this module to override Spotlight::ExhibitsController
module PrependedControllers::ExhibitsController
  # Overrides published exhibit order in so that exhibits are ordered first by asc weight, then by most recently published
  def index
    @published_exhibits = @exhibits.includes(:thumbnail).published.order(weight: :asc, published_at: :desc).page(params[:page])
    @published_exhibits = @published_exhibits.tagged_with(params[:tag]) if params[:tag]
    respond_to do |format|
      format.html { handle_html_response }
      format.rss { handle_rss_response }
    end
  end

  private

  def handle_html_response
    if @exhibits.one?
      redirect_to @exhibits.first, flash: flash.to_h
    else
      render layout: 'spotlight/home'
    end
  end

  def handle_rss_response
    limit = params[:limit].to_i
    limit = 100 if limit <= 0
    @rss_feed = @published_exhibits.limit(limit)
    render layout: false
  end
end
