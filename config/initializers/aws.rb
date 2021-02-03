Aws.config.update({
  region: ENV["s3_region"],
  credentials: Aws::Credentials.new(ENV["aws_key_id"], ENV["aws_access_secret_key"])
})