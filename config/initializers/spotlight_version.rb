SPOTLIGHT_VERSION =
    if File.exist?('Gemfile.lock')
      version_match = `grep 'blacklight-spotlight (' Gemfile.lock`
      version = version_match.present? ? version_match.lines.first.chomp.lstrip.split(/ /)[1].gsub('(','').gsub(')','') : "Unknown".freeze
      version.freeze
    else
      "Unknown".freeze
    end
