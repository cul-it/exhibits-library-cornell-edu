require 'erb'

# this class overrides the default Blacklight::FieldPresenter to allow us to
# render markdown in the spotlight_upload_description_tesim field as html links LP-481
# all other fields are using the default Blacklight::FieldPresenter renderering

class CustomFieldPresenter < Blacklight::FieldPresenter
  def render
    if field_config.field == 'spotlight_upload_description_tesim'
      escaped_values = values.map do |value|
        ERB::Util.html_escape(value).gsub(/\[([^\[]+)\]\(([^\)]+)\)/, '<a href="\2">\1</a>')
      end
      view_context.raw(escaped_values.join(field_config.delimiter))
    else
      super
    end
  end
end