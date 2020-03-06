class AccessModeService
  def self.limit_access_to_site_admins?
    result = ENV['ACCESS_MODE']&.casecmp?('SITE_ADMIN_ONLY')
    result.nil? ? false : result
  end

  def self.site_admins
    site_admins = ENV['SITE_ADMINS']&.split(';')
    site_admins.nil? ? [] : site_admins
  end
end
