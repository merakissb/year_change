class ExcelFile < ApplicationRecord
  belongs_to :user
  has_one_attached :file

  validates :school, presence: true, length: { minimum: 2, maximum: 50 }
  validates :rbd, presence: true, length: { minimum: 2, maximum: 10 }
  validates :file, attached: true, content_type: { in: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', message: 'is not excel file'}, size: { less_than: 3.megabytes }
end