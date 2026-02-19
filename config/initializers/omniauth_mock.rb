if (Rails.env.development? && ENV['MOCK_USER'].present?) || Rails.env.test?
  # Mock sso login
  OmniAuth.config.test_mode = true
  mock_user = Rails.env.development? ? ENV['MOCK_USER'] : 'test123@cornell.edu'
  OmniAuth.config.mock_auth[:saml] = OmniAuth::AuthHash.new({
                                                              provider: 'saml',
                                                              uid: '0123456789',
                                                              info: {
                                                                netid: mock_user.gsub(/@.+$/, ''),
                                                                email: mock_user
                                                              }
                                                            })
end