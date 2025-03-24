# frozen_string_literal: true

# Based on the Module#prepend pattern in ruby.
# Uses the to_prepare Rails hook in application.rb to inject this module to override Spotlight::ExhibitsController
module PrependedControllers::ExhibitsController
  # Overrides published exhibit order in so that exhibits are ordered first by asc weight, then by most recently published
  def index
    @published_exhibits = @exhibits.includes(:thumbnail).published.order(weight: :asc, published_at: :desc).page(params[:page])
    @published_exhibits = @published_exhibits.tagged_with(params[:tag]) if params[:tag]
    if @exhibits.one?
      redirect_to @exhibits.first, flash: flash.to_h
    else
      render layout: 'spotlight/home'
    end
  end
end
