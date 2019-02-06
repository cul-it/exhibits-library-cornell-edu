class S3
  class << self
    def connected?
      ENV['S3_KEY_ID'].present?
    end

    # def bucket
    #   @bucket ||= Aws::S3::Resource.new(region: ENV['AWS_REGION']).bucket(ENV['AWS_S3_BUCKET'])
    # end
  end
end
