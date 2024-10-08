### CUSTOMIZATION (elr) - new initializer for S3 storage support
if ENV['S3_KEY_ID'].present?
  CarrierWave.configure do |config|
    config.storage = :aws
    config.aws_bucket = ENV['S3_BUCKET']
    config.aws_acl = 'bucket-owner-full-control'

    config.aws_credentials = {
      access_key_id: ENV['S3_KEY_ID'],
      secret_access_key: ENV['S3_SECRET_KEY'],
      region: ENV['S3_BUCKET_REGION']
    }
  end
elsif Rails.env.test? || Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.root = Rails.root.join('spec/uploads')
    config.storage = :file
    config.enable_processing = false
  end
end
