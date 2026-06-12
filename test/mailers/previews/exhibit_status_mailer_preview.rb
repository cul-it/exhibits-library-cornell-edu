# frozen_string_literal: true

# Preview email on development:
# http://localhost:9292/rails/mailers/exhibit_status_mailer/send_exhibit_status_email

class ExhibitStatusMailerPreview < ActionMailer::Preview
  def send_exhibit_status_email
    exhibit = create_exhibit
    ExhibitStatusMailer.send_exhibit_status_email(exhibit)
  end

  private

  def create_exhibit
    exhibit = OpenStruct.new(
      published: true,
      title: 'Example Exhibit',
      subtitle: 'not real',
      description: 'This is fake exhibit data used for email preview.',
      published_at: Time.current - 1.day,
      updated_at: Time.current,
      slug: 'example-exhibit'
      # Unpublished exhibit email, use these:
      # published: false,
      # published_at: Time.current - 7.days
    )
    exhibit.define_singleton_method(:published?) { published }
    exhibit
  end
end
