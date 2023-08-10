class BibliographyController < Spotlight::ApplicationController
  before_action do
    authorize!(:read, current_exhibit)
  end

  def index; end
end
