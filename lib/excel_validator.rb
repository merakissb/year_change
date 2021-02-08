module ExcelValidator
  def self.process(file)
    xlsx = Roo::Spreadsheet.open(file.service_url, extension: :xlsx)
    xlsx.default_sheet = xlsx.sheets.first
    xlsx.info
  end
end