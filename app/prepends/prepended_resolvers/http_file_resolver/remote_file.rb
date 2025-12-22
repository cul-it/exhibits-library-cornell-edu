# frozen_string_literal: true

# Based on the Module#prepend pattern in ruby.
# Uses the to_prepare Rails hook to inject this module to override Riiif::HttpFileResolver::RemoteFile

module PrependedResolvers::HttpFileResolver::RemoteFile
  private

  def file_name
    @cache_file_name ||= ::File.join(cache_path, Digest::MD5.hexdigest(cache_url(url)) + ext.to_s)
  end

  def cache_url(url)
    cache_url = URI.parse(url)
    cache_url.query = nil
    cache_url.to_s
  rescue URI::Error
    url
  end
end
