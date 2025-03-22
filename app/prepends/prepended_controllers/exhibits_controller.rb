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

  protected

  # override exhibit_params method to convert tag_list params from array to comma separated list
  def exhibit_params
    permitted_params = params.require(:exhibit).permit(
      :title,
      :subtitle,
      :description,
      :published,
      tag_list: [],
      contact_emails_attributes: [:id, :email],
      languages_attributes: [:id, :public]
    )
    permitted_params[:tag_list] = simplify_tag_list(permitted_params[:tag_list])
    permitted_params
  end

  # convert tag_list params from array to comma separated list
  def simplify_tag_list(tag_list)
    tag_list&.delete_if { |t| t.empty? }&.join(",")
  end
end
