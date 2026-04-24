# frozen_string_literal: true

# Preview email on development: 
# http://localhost:9292/rails/mailers/exhibit_status_mailer/send_exhibit_status_email

class ExhibitStatusMailerPreview < ActionMailer::Preview
  def send_exhibit_status_email
    # Published exhibit email
    published_exhibit = OpenStruct.new(
      published: true,
      title: 'Example Exhibit',
      subtitle: 'not real',
      description: 'This is fake exhibit data used for email preview.',
      published_at: Time.now - 1.day,
      updated_at: Time.now,
      slug: 'example-exhibit'
    )
    published_exhibit.define_singleton_method(:published?) { published }

    # Unpublished exhibit email
    unpublished_exhibit = OpenStruct.new(
      published: false,
      title: 'Example Exhibit',
      subtitle: 'not real',
      description: 'This is fake exhibit data used for email preview.',
      published_at: Time.now - 7.days,
      updated_at: Time.now,
      slug: 'example-exhibit'
    )
    unpublished_exhibit.define_singleton_method(:published?) { published }
    
    # Choose which email to preview
    ExhibitStatusMailer.send_exhibit_status_email(unpublished_exhibit)
  end
end
