SPOTLIGHT_VERSION =
  if File.exist?('Gemfile.lock')
    version_match = `grep 'blacklight-spotlight (' Gemfile.lock`
    version = version_match&.lines&.first&.chomp&.lstrip&.split(/ /)&.second&.delete('(')&.delete(')')
    version ? version.freeze : "Unknown".freeze
  else
    "Unknown".freeze
  end
