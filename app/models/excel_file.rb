class ExcelFile < ApplicationRecord
  belongs_to :user
  has_one_attached :input_file
  has_one_attached :output_file

  validates :school, presence: true, length: { minimum: 2, maximum: 50 }
  validates :rbd, presence: true, length: { minimum: 2, maximum: 10 }
  validates :input_file, attached: true, content_type: { in: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', message: 'is not excel file'}, size: { less_than: 3.megabytes }

  before_destroy :delete_bucket_file #callback.

  def delete_bucket_file
    s3_client = Aws::S3::Client.new(
      credentials: Aws::Credentials.new(ENV["aws_key_id"], ENV["aws_access_secret_key"]),
      region: ENV["s3_region"]
    )
  
    # delete object by passing bucket and object key
    s3_response = s3_client.delete_object({
      bucket: ENV["s3_bucket"],
      key: input_file.key
    })
  end

  def validate_file
    #FileValidator.process(input_file)
    ExcelValidator.process(input_file)
    excel = File.open('output.xlsx')
    output_file.attach(io: excel, filename: 'output.xlsx')
    save!
  end
end