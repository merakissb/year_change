class ExcelFile < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  validates :school, presence: true, length: { minimum: 2, maximum: 50 }
  validates :rbd, presence: true, length: { minimum: 2, maximum: 10 }
  validates :file, attached: true, content_type: { in: 'application/xlsx', message: 'is not a xlsx' }, size: { less_than: 3.megabytes }
end
